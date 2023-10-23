class OrganizationsController < ApplicationController
  skip_before_action :block_user_belongs_to_no_organization, only: %i(new create)
  before_action :block_user_belongs_to_organization, only: %i(new create)
  before_action :block_normal_user, except: %i(new create show edit)
  before_action :set_organization, only: %i(show edit update destroy)

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.create_with_admin(organization_params, current_user)
    if @organization.errors.blank?
      flash[:notice] = '組織を作成しました。'
      redirect_to organization_path
    else
      flash.now[:alert] = '組織を作成できませんでした。'
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @members = @organization.users
  end

  def edit
  end

  def update
    if @organization.update(organization_params)
      flash[:notice] = '組織情報を更新しました。'
      redirect_to organization_path
    else
      flash.now[:alert] = '組織情報を更新できませんでした。'
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @organization.transaction do
      @organization.users = []
      @organization.destroy
    end
    flash[:notice] = '組織を削除しました。'
    redirect_to new_organization_path
  end

  private

  def block_user_belongs_to_organization
    if current_user.organization.present?
      flash[:alert] = 'すでに組織に所属しています。'
      redirect_to organization_path
    end
  end

  def block_normal_user
    redirect_to projects_path unless current_user.is_admin?
  end

  def set_organization
    @organization = current_user.organization
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
