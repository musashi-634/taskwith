class TasksController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks.order(:row_order)
  end
end
