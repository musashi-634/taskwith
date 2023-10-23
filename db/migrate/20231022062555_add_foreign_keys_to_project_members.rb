class AddForeignKeysToProjectMembers < ActiveRecord::Migration[7.0]
  def up
    change_column :project_members, :project_id, :bigint
    change_column :project_members, :user_id, :bigint
    add_foreign_key :project_members, :projects
    add_foreign_key :project_members, :users
  end

  def down
    remove_foreign_key :project_members, :projects
    remove_foreign_key :project_members, :users
    remove_index :project_members, :user_id
    change_column :project_members, :project_id, :integer
    change_column :project_members, :user_id, :integer
  end
end
