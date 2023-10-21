class AddForeignKeyToOrganizationIdInUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :organization_id, :bigint
    add_foreign_key :users, :organizations
  end

  def down
    remove_foreign_key :users, :organizations
    remove_index :users, :organization_id
    change_column :users, :organization_id, :integer
  end
end
