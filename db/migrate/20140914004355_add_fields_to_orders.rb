class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping, :string
    add_column :orders, :shipping_total, :integer
  end
end
