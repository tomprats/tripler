class Order < ActiveRecord::Base
  has_many :packages
  has_many :order_items
  belongs_to :user
  belongs_to :shipped_admin, class_name: "User"

  accepts_nested_attributes_for :packages
  accepts_nested_attributes_for :order_items

  validates_presence_of(
    :first_name, :last_name, :email,
    :phone_number, :address1,
    :city, :state, :zipcode
  )

  after_initialize :update_total
  before_save :update_total
  before_save :validate_discount

  def self.default_scope
    order(created_at: :desc)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def date
    created_at.strftime("%m/%d/%Y")
  end

  def quantity
    q = 0
    order_items.each { |order_item| q += order_item.quantity }
    q
  end

  def subtotal
    subtotal = 0
    order_items.each do |order_item|
      subtotal += (order_item.price || order_item.product.price) * order_item.quantity
    end
    subtotal
  end

  def package_params?
    [
      first_name, last_name, email, phone_number,
      address1, city, state, zipcode
    ].all? { |p| !p.empty? }
  end

  def origin
    @origin ||= ActiveShipping::Location.new(
      name: "Triple R Farms",
      phone: "717-542-4022",
      address1: "890 Heritage Hills Dr",
      city: "York",
      state: "PA",
      zip: "17403"
    )
  end

  def destination
    @destination ||= ActiveShipping::Location.new(
      name: name,
      phone: phone_number,
      address1: address1,
      address2: address2,
      city: city,
      state: state,
      zip: zipcode
    )
  end

  def stamps
    return @stamps if @stamps

    options = {
      integration_id: ENV["STAMPS_INTEGRATION_ID"],
      username:       ENV["STAMPS_USERNAME"],
      password:       ENV["STAMPS_PASSWORD"]
    }
    options[:test] = true if Rails.env.development?
    @stamps = ActiveShipping::Stamps.new(options)
  end

  def validate_address
    stamps.validate_address(destination)
  end

  def find_rate
    return unless Package.free_shipping?

    find_rates.min_by { |_,r| r[:price] }.last
  end

  def find_rates
    split_packages

    rates = []
    self.packages.each do |package|
      rates.push stamps.find_rates(
        origin, destination, package.active_package,
        { package_type: "Package" }
      )
    end

    # Combine ones with the same service codes
    combined_rates = {}
    rates.each do |rate|
      rate.rates.each do |r|
        if Order.accepted_services.include? r.service_code
          combined_rates[r.service_code] ||= {
            rate: r.service_code,
            service: r.service_name,
            date: r.delivery_date,
            price: 0,
            count: 0
          }
          combined_rates[r.service_code][:price] += r.total_price
          combined_rates[r.service_code][:count] += 1
        end
      end
    end

    combined_rates.delete_if { |s, r| r[:count] < packages.length }
    combined_rates
  end

  def split_packages
    quantity = 0
    package = Package.new
    self.packages = [package]
    self.order_items.each do |order_item|
      package, quantity = add_to_package(package, quantity, order_item)
    end
  end

  def service_type
    ActiveShipping::Stamps::SERVICE_TYPES.invert[self.shipping]
  end

  def self.accepted_services
    [
      "US-FC", # 'USPS First-Class Mail'
      "US-PM", # 'USPS Priority Mail'
      "US-XM", # 'USPS Express Mail'
      "US-PS" # 'USPS Parcel Select'
    ]
  end

  def create_shipment
    options = {
      package_type: "Package",
      service: service_type,
      image_type: "Jpg",
      delivery_notification: true
    }

    purchase_postage(100, 100)

    packages.each do |package|
      package.create_shipment(options)
    end
  end

  def purchase_postage(amount, minimum)
    account = stamps.account_info
    stamps.purchase_postage(amount, account.control_total) if account.control_total.to_i < minimum
  end

  def checkout(card_token, user_id)
    self.user_id = user_id

    split_packages
    if !quantity.zero? && !shipping.blank? && card_token
      Stripe.api_key = ENV["STRIPE_SECRET"]
      charge_description = "Triple R Farms delicious Jerky infused with Cowboy Coffee."
      options = {
        amount: update_total,
        currency: "usd",
        description: charge_description
      }
      if user_id
        current_user = User.find(user_id)
        options[:customer] = current_user.create_customer_token(card_token)
      else
        options[:card] = card_token
      end

      self.charge_token = Stripe::Charge.create(options).id
      self.paid = true
      self.paid_date = DateTime.now

      save

      begin
        create_shipment
      rescue => error
        AdminEmailer.error_email(self, error).deliver_now

        raise error
      end
    end
  end

  def self.from_session(hash)
    params = ActionController::Parameters.new(hash)
    permitted = params.permit(
      :first_name, :last_name, :email,
      :phone_number, :address1, :address2,
      :city, :state, :zipcode,
      :shipping, :shipping_total,
      :discount,
      order_items_attributes: [
        :product_id, :quantity
      ]
    )
    Order.new(permitted)
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def validate_discount
    # Based off of the assumption update_total runs first
    return false unless total_price > 0

    # Add coupon validations here
    return discount > 0 ? Package.free_shipping? : true
  end

  def update_total
    self.total_price = subtotal + (shipping_total || 0) - discount
  end

  def add_to_package(package, quantity, order_item)
    if quantity + order_item.quantity <= Package.size
      quantity = quantity + order_item.quantity
      package.order_items << order_item
    else
      space = Package.size - quantity
      order_item.quantity = order_item.quantity - space

      unless space.zero?
        item = order_item.dup
        item.quantity = space
        self.order_items << item
        package.order_items << item
      end

      package = Package.new
      self.packages << package
      package, quantity = add_to_package(package, 0, order_item)
    end

    return package, quantity
  end
end
