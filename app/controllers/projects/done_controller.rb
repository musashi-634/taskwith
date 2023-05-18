class Projects::DoneController < ApplicationController
  def index
    @done_projects = Project.done
  end
end
