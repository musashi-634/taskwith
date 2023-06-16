class AddIsArchivedToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :is_archived, :boolean, after: :is_done, null: false, default: false
  end
end
