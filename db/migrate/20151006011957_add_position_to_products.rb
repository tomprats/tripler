class AddPositionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :position, :integer, default: 100
  end
end
