class CreateProjectMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_members do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end

    add_index :project_members, %i(project_id user_id), unique: true
  end
end
