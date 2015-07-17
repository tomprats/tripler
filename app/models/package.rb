class Package < ActiveRecord::Base
  belongs_to :order
  has_many :order_items

  after_initialize :set_uuid, if: :new_record?

  mount_uploader :label, PackageLabelUploader

  delegate :stamps, :origin, :destination, :package, to: :order, allow_nil: true

  def create_shipment(options)
    options[:integrator_tx_id] = uuid
    response = stamps.create_shipment(origin, destination, package, [], options)

    update(remote_label_url: response.label_url)
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
