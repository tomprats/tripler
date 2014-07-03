class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.string :description
      t.string :charge_token

      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end

    create_table :order_items do |t|
      t.integer :order_id
      t.integer :total_price
      t.integer :quantity

      t.integer :product_id
      t.integer :price
      t.string :name
      t.string :description
      t.string :image

      t.timestamps
    end

    create_table :products do |t|
      t.integer :price
      t.string :name
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end

