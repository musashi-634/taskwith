class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :block_user_belongs_to_no_organization, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_my_projects, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i(name organization_id))
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  private

  def block_user_belongs_to_no_organization
    redirect_to new_organization_path if current_user.organization.blank?
  end

  def block_user_belongs_to_other_organization(requested_object)
    if requested_object.organization != current_user.organization
      redirect_to projects_path
    end
  end

  def set_my_projects
    @my_projects = current_user.projects.not_archived.descend_by_updated_at
  end
end
