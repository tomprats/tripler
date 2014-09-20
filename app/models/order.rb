class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :user

  accepts_nested_attributes_for :order_items

  validates_presence_of(
    :total_price,
    :description,
    :first_name,
    :last_name,
    :phone_number,
    :address,
    :city,
    :state,
    :zipcode,
    :shipping,
    :shipping_total
  )

  def name
    "#{first_name} #{last_name}"
  end

  def date
    created_at.strftime("%m/%d/%Y")
  end

  def self.find_shipping(packs, destination_zipcode)
    # Create package(s) out of items
    packages = []
    package = Package.new(
      (2 * 8), # oz
      [3, 9, 7], #inches
      units: :imperial # not grams, not centimetres
    )
    packs.times { packages.push(package) }

    origin = Location.new(
      country: "US",
      zip: "17402"
    )

    destination = Location.new(
      country: "US",
      zip: destination_zipcode
    )

    options = {
      login:    ENV["FEDEX_LOGIN"],
      password: ENV["FEDEX_PASSWORD"],
      key:      ENV["FEDEX_KEY"],
      account:  ENV["FEDEX_ACCOUNT"],
      meter:    ENV["FEDEX_METER"],
      test:     true
    }

    fedex = FedEx.new(options)
    fedex.find_rates(origin, destination, packages)
  end
end
