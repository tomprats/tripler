class Product < ActiveRecord::Base
  has_many :order_items

  validates_presence_of :name, :description, :price
end
