class OrganizationsController < ApplicationController
  skip_before_action :block_user_belongs_to_no_organization, only: %i(new create)
  before_action :block_user_belongs_to_organization, only: %i(new create)

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
    @organization = current_user.organization
    @members = @organization.users
  end

  private

  def block_user_belongs_to_organization
    if current_user.organization.present?
      flash[:alert] = 'すでに組織に所属しています。'
      redirect_to organization_path
    end
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
