class AddForeignKeysToTaskStaffs < ActiveRecord::Migration[7.0]
  def up
    change_column :task_staffs, :task_id, :bigint
    change_column :task_staffs, :user_id, :bigint
    add_foreign_key :task_staffs, :tasks
    add_foreign_key :task_staffs, :users
  end

  def down
    remove_foreign_key :task_staffs, :tasks
    remove_foreign_key :task_staffs, :users
    remove_index :task_staffs, :user_id
    change_column :task_staffs, :task_id, :integer
    change_column :task_staffs, :user_id, :integer
  end
end
