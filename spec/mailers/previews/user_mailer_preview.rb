# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def invitation_instructions
    inviter = User.first
    invitee = User.new(
      email: 'test@example.com',
      invited_by_type: inviter.class,
      invited_by_id: inviter.id,
      invitation_created_at: Time.zone.now
    )
    invitation_token = 'abcdef'
    UserMailer.invitation_instructions(invitee, invitation_token)
  end
end
