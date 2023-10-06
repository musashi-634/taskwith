class CreateTaskStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :task_staffs do |t|
      t.integer :task_id
      t.integer :user_id

      t.timestamps
    end

    add_index :task_staffs, %i(task_id user_id), unique: true
  end
end
