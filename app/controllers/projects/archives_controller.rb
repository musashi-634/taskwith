class Projects::ArchivesController < ApplicationController
  before_action :set_project, only: %i(create destroy)
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

  def destroy
    if @project.update(is_archived: false)
      flash[:notice] = 'プロジェクトを復元しました。'
      redirect_to projects_archives_path
    else
      flash.now[:alert] = 'プロジェクトを復元できませんでした。'
      @archived_projects = current_user.organization.projects.archived.descend_by_updated_at
      render 'index', status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end
end
