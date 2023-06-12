class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_my_undone_projects, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  private

  def set_my_undone_projects
    @my_undone_projects = current_user.projects.undone.descend_by_updated_at
  end
end
