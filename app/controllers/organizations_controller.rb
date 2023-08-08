class OrganizationsController < ApplicationController
  skip_before_action :block_user_belongs_to_no_organization, only: :new

  def new
    if current_user.organization.present?
      flash[:alert] = 'すでに組織に所属しています。'
      redirect_to organization_path
    end
  end

  def show
    @organization = current_user.organization
  end
end
