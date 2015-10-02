class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :package
  belongs_to :product

  after_initialize :set_details, if: :new_record?
  after_initialize :update_total, if: :new_record?
  before_save :update_total

  def self.default_scope
    order(created_at: :desc)
  end

  private
  def set_details
    self.price = product.price
    self.name = product.name
    self.description = product.description
    self.image = product.image
  end

  def update_total
    self.total_price = (price || product.price) * quantity
  end
end
