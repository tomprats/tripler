class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :phone_number
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :customer_token

      t.timestamps
    end
  end
end
