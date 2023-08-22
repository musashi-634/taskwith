class Projects::ArchivedController < ApplicationController
  def index
    @archived_projects = current_user.organization.projects.archived.descend_by_updated_at
  end
end
