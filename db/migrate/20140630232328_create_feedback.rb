class CreateFeedback < ActiveRecord::Migration
  def change
    create_table :feedback do |t|
      t.string :name
      t.string :email
      t.string :message
      t.integer :user_id

      t.timestamps
    end
  end
end
