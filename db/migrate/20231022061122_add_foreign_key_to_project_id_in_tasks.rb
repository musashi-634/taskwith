class AddForeignKeyToProjectIdInTasks < ActiveRecord::Migration[7.0]
  def up
    change_column :tasks, :project_id, :bigint
    add_foreign_key :tasks, :projects
  end

  def down
    remove_foreign_key :tasks, :projects
    remove_index :tasks, :project_id
    change_column :tasks, :project_id, :integer
  end
end
