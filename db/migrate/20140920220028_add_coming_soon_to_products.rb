class AddComingSoonToProducts < ActiveRecord::Migration
  def change
    add_column :products, :coming_soon, :boolean, default: false
  end
end
