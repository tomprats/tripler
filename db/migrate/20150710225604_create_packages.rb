class CreatePackages < ActiveRecord::Migration
  def change
    rename_column :users, :address, :address1
    add_column :users, :address2, :string

    rename_column :orders, :address, :address1
    add_column :orders, :address2, :string
    add_column :orders, :email, :string
    add_column :orders, :paid, :boolean, default: false
    add_column :orders, :paid_date, :datetime

    create_table :packages do |t|
      t.integer :order_id
      t.string :uuid
      t.string :label

      t.timestamps
    end

    add_column :order_items, :package_id, :integer
  end
end
