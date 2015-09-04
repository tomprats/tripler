class Product < ActiveRecord::Base
  has_many :order_items

  validates_presence_of :name, :description, :price, :image

  mount_uploader :image, ProductImageUploader

  def self.default_scope
    order(:name)
  end

  # Can be added to db if multiple weights
  def weight
    2 # ounces
  end
end
