class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :user

  accepts_nested_attributes_for :order_items
end
