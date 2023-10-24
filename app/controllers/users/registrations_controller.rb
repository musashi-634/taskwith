class Users::RegistrationsController < DeviseInvitable::RegistrationsController
  before_action :block_guest_user, only: %i(update destroy)

  def destroy
    super do |user|
      organization = user.organization
      if organization && user.is_admin? && organization.reload.users.where(is_admin: true).blank?
        organization.transaction do
          organization.users = []
          organization.destroy!
        end
      end
    end
  end

  protected

  def after_update_path_for(resource)
    users_account_path
  end

  private

  def block_guest_user
    if resource.email == User::GUEST_EMAIL
      redirect_to projects_path, alert: 'ゲストユーザーは更新・削除できません。'
    end
  end
end
