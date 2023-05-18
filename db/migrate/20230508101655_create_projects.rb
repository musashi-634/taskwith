class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.boolean :is_done, null: false, default: false

      t.timestamps
    end
  end
end
