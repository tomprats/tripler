class AddShippedFieldToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped, :boolean, default: false
    add_column :orders, :shipped_date, :datetime
    add_column :orders, :shipped_admin_id, :integer
  end
end
