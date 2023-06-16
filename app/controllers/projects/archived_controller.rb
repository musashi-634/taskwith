class Projects::ArchivedController < ApplicationController
  def index
    @archived_projects = Project.archived.descend_by_updated_at
  end
end
