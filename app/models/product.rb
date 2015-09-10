class Product < ActiveRecord::Base
  has_many :order_items

  validates_presence_of :name, :description, :price, :image

  mount_uploader :image, ProductImageUploader

  def self.default_scope
    order(:name)
  end

  def self.normal
    where("description NOT ILIKE ?", "%Coffee%")
  end

  def self.coffee
    where("description ILIKE ?", "%Coffee%")
  end

  def self.original
    where("description ILIKE ?", "%Original%")
  end

  # Can be added to db if multiple weights
  def weight
    2 # ounces
  end
end
