class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name

      t.timestamps
    end

    add_column :users, :organization_id, :integer, after: :id
    add_column :projects, :organization_id, :integer, after: :id
  end
end
