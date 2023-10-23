class Users::InvitationsController < Devise::InvitationsController
  before_action :block_user_belongs_to_no_organization, only: %i(new create)
  before_action :block_normal_user, except: %i(new edit update)

  def create
    @user = User.find_by(email: params[:user][:email])
    does_user_exist = @user.present?

    if does_user_exist
      if @user.organization.blank?
        @user.invite!(current_user) { |user| user.skip_invitation = true }
        @user.organization_id = current_user.organization.id
        @user.accept_invitation
        @user.save
      else
        if is_flashing_format?
          set_flash_message :alert, :already_joined, { now: true, email: @user.email }
        end
        render 'new', status: :unprocessable_entity
        return
      end
    else
      @user = User.invite!(invite_params, current_user)
    end

    if @user.errors.empty?
      if does_user_exist
        set_flash_message :notice, :user_added, { email: @user.email } if is_flashing_format?
      else
        set_flash_message :notice, :send_instructions, { email: @user.email } if is_flashing_format?
      end
      redirect_to organization_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  protected

  def after_invite_path_for(inviter, invitee = nil) # rubocop:disable Airbnb/OptArgParameters
    organization_path
  end

  def after_accept_path_for(resource)
    projects_path
  end

  private

  def block_normal_user
    redirect_to projects_path unless current_user.is_admin?
  end
end
