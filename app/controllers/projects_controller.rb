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
    @project = current_user.organization.projects.new(project_params)
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

  def edit
    @organization_members = @project.organization.users
  end

  def update
    if @project.update(project_params)
      flash[:notice] = 'プロジェクト情報を更新しました。'
      redirect_to projects_path
    else
      flash.now[:alert] = 'プロジェクト情報を更新できませんでした。'
      @organization_members = @project.organization.users
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :is_done, :is_archived, user_ids: [])
  end
end
