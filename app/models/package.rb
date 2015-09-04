class Package < ActiveRecord::Base
  belongs_to :order
  has_many :order_items

  after_initialize :set_uuid, if: :new_record?

  mount_uploader :label, PackageLabelUploader

  delegate :stamps, :origin, :destination, to: :order, allow_nil: true

  def create_shipment(options)
    options[:integrator_tx_id] = uuid
    response = stamps.create_shipment(origin, destination, active_package, [], options)

    update(remote_label_url: response.label_url)
  end

  def active_package
    weight = value = 0
    order_items.each do |order_item|
      weight += order_item.quantity * order_item.product.weight
      value += order_item.quantity * order_item.product.price
    end

    ActiveShipping::Package.new(
      weight, # ounces
      [3, 9, 7], # inches
      value: value, # dollars
      units: :imperial # not grams, not centimetres
    )
  end

  def self.size
    8
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
