class AddIsAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_admin, :boolean, after: :encrypted_password, null: false, default: false
  end
end
