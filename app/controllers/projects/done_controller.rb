class Projects::DoneController < ApplicationController
  def index
    @done_projects = Project.done.descend_by_updated_at
  end
end
