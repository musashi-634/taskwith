class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.string :name
      t.date :start_at
      t.date :end_at
      t.text :description
      t.boolean :is_done, null: false, default: false
      t.integer :row_order

      t.timestamps
    end
  end
end
