class Projects::ArchivesController < ApplicationController
  before_action :set_project, only: :create
  before_action -> {
    block_user_belongs_to_other_organization(@project)
  }, except: :index

  def index
    @archived_projects = current_user.organization.projects.archived.descend_by_updated_at
  end

  def create
    if @project.update(is_archived: true)
      flash[:notice] = 'プロジェクトをアーカイブしました。'
      redirect_to projects_path
    else
      flash.now[:alert] = 'プロジェクトをアーカイブできませんでした。'
      @project_members = @project.users
      render 'projects/show', status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
