class AddForeignKeyToOrganizationIdInProjects < ActiveRecord::Migration[7.0]
  def up
    change_column :projects, :organization_id, :bigint
    add_foreign_key :projects, :organizations
  end

  def down
    remove_foreign_key :projects, :organizations
    remove_index :projects, :organization_id
    change_column :projects, :organization_id, :integer
  end
end
