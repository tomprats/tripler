class Product < ActiveRecord::Base
  has_many :order_items

  validates_presence_of :name, :description, :price, :image

  mount_uploader :image, ProductImageUploader

  def self.default_scope
    order(:name)
  end
end
