class AddMoreFieldsToOrders < ActiveRecord::Migration
  def change
    rename_column :users, :address, :address1
    add_column :users, :address2, :string

    rename_column :orders, :address, :address1
    add_column :orders, :address2, :string
    add_column :orders, :uuid, :string
    add_column :orders, :email, :string
    add_column :orders, :shipment_id, :string

    add_column :orders, :paid, :boolean, default: false
    add_column :orders, :paid_date, :datetime
  end
end
