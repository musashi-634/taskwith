class Users::RegistrationsController < DeviseInvitable::RegistrationsController
  def destroy
    super do |user|
      organization = user.organization
      if organization && organization.reload.users.blank?
        organization.destroy
      end
    end
  end

  protected

  def after_update_path_for(resource)
    users_path
  end
end
