class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params.require(:project).permit(:name, :description, :is_done))
    if @project.save
      flash[:notice] = 'プロジェクトを作成しました。'
      redirect_to projects_path
    else
      flash.now[:alert] = 'プロジェクトを作成できませんでした。'
      render 'new', status: :unprocessable_entity
    end
  end
end
