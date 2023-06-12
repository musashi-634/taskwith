class ProjectsController < ApplicationController
  def index
    @undone_projects = Project.undone.descend_by_updated_at.includes(:users).order("users.name ASC")
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(
      **params.require(:project).permit(:name, :description, :is_done), users: [current_user]
    )
    if @project.save
      flash[:notice] = 'プロジェクトを作成しました。'
      redirect_to projects_path
    else
      flash.now[:alert] = 'プロジェクトを作成できませんでした。'
      render 'new', status: :unprocessable_entity
    end
  end
end
