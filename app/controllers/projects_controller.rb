class ProjectsController < ApplicationController
  before_action :set_project, only: %i(show edit update destroy)
  before_action -> {
    block_user_belongs_to_other_organization(@project)
  }, except: %i(index new create)

  def index
    @projects = current_user.organization.projects.not_archived.
      descend_by_updated_at.includes(:users).order("users.name ASC")
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.organization.projects.new(
      **params.require(:project).permit(:name, :description, :is_done, :is_archived),
      users: [current_user]
    )
    if @project.save
      flash[:notice] = 'プロジェクトを作成しました。'
      redirect_to projects_path
    else
      flash.now[:alert] = 'プロジェクトを作成できませんでした。'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @project_members = @project.users
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
