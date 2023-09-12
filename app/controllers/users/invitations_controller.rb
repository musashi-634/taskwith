class Users::InvitationsController < Devise::InvitationsController
  before_action :block_user_belongs_to_no_organization, only: %i(new create)

  protected

  def after_invite_path_for(inviter, invitee = nil) # rubocop:disable Airbnb/OptArgParameters
    organization_path
  end
end
