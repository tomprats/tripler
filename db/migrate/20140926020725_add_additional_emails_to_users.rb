class AddAdditionalEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :additional_emails, :string
  end
end
