class Users::RegistrationsController < DeviseInvitable::RegistrationsController
  protected

  def after_update_path_for(resource)
    users_path
  end
end
