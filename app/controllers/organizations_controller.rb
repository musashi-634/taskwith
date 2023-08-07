class OrganizationsController < ApplicationController
  def new
    if current_user.organization.present?
      flash[:alert] = 'すでに組織に所属しています。'
      redirect_to organization_path
    end
  end

  def show
    redirect_to new_organization_path if current_user.organization.blank?
    @organization = current_user.organization
  end
end
