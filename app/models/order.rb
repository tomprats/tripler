class Order < ActiveRecord::Base
  include ActiveShipping

  has_many :order_items
  belongs_to :user
  belongs_to :shipped_admin, class_name: "User"

  accepts_nested_attributes_for :order_items

  validates_presence_of(
    :first_name, :last_name, :email,
    :phone_number, :address1, :address2,
    :city, :state, :zipcode
  )

  after_initialize :set_uuid, if: :new_record?
  after_initialize :update_total
  before_save :update_total

  def name
    "#{first_name} #{last_name}"
  end

  def date
    created_at.strftime("%m/%d/%Y")
  end

  def subtotal
    subtotal = 0
    order_items.each do |order_item|
      subtotal += order_item.product.price * order_item.quantity
    end
    subtotal
  end

  def packs
    quantity = order_items.collect(&:quantity).sum
    quantity / 8
  end

  def packless
    quantity = order_items.collect(&:quantity).sum
    quantity % 8
  end

  def origin
    @origin ||= Location.new(
      name: "Triple R Farms",
      address1: "890 heritage hills Dr",
      city: "York",
      state: "PA",
      zip: "17403"
    )
  end

  def destination
    @destination ||= Location.new(
      name: name,
      address1: address1,
      address2: address2,
      city: city,
      state: state,
      zip: zipcode
    )
  end

  def package
    @package ||= Package.new(
      (2 * 8), # oz
      [3, 9, 7], # inches
      value: 6.25 * 8, # dollars
      units: :imperial # not grams, not centimetres
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
    @stamps = Stamps.new(options)
  end

  def validate_address
    # Validate their address, handle response
    #
    # 1. Good Address
    # 2. Slightly off, is this one ok?
    # 3. Wrong Street, Re-Enter
    # 4. Wrong City/State/Zip, Re-Enter
  end

  def find_rates
    options = {
      package_type: "Package",
    }
    stamps.find_rates(origin, destination, package, options)
  end

  def create_shipment
    # MIGHT WANT TO ADD SHIPMENT ID TO DB
    # MIGHT WANT TO ADD UUID TO DB
    #
    options = {
      integrator_tx_id: uuid,
      package_type: "Package",
      service: "What the user chose",
      image_type: "Jpg",
      delivery_notification: true
    }
    # options[:add_ons]
    #
    # email: "for shipment notification"
    # Add Shipment Notification
    # CCToAccountHolder = true
    # https://github.com/Shopify/active_shipping/blob/master/lib/active_shipping/carriers/stamps.rb#L399
    # Send label to us
    # https://github.com/Shopify/active_shipping/blob/master/lib/active_shipping/carriers/stamps.rb#L432
    #
    # create it
    #
    # save shipment id
  end

  def find_tracking_info
    # use shipment id
  end

  def self.from_session(hash)
    params = ActionController::Parameters.new(hash)
    permitted = params.permit(
      :first_name, :last_name, :email,
      :phone_number, :address1, :address2,
      :city, :state, :zipcode,
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

  def update_total
    self.total_price = subtotal + (shipping_total || 0)
  end
end
