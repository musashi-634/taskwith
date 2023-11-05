require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe '#invitation_instructions' do
    let(:user) { create(:user, :with_organization) }
    let(:invitee) do
      User.invite!({ email: attributes_for(:user)[:email], skip_invitation: true }, user)
    end
    let(:invitation_mail) do
      UserMailer.invitation_instructions(invitee, invitee.raw_invitation_token)
    end

    it '招待メールのheaderの内容が適切なこと' do
      expect(invitation_mail.from).to eq [Rails.application.credentials.dig(:gmail, :email)]
      expect(invitation_mail.to).to eq [invitee.email]
      expect(invitation_mail.subject).to eq(
        "[TaskWith] #{user.name}様から、「#{user.organization.name}」という組織に招待されました"
      )
    end

    it '招待メールのhtml形式のbodyの内容が適切なこと' do
      expect(invitation_mail.body.to_s).to include invitee.email
      expect(invitation_mail.body.to_s).to include "#{user.name}（#{user.email}）"
      expect(invitation_mail.body.to_s).to include "#{user.organization.name}"
      expect(invitation_mail.body.to_s).to include(
        accept_user_invitation_url(invitation_token: invitee.raw_invitation_token)
      )
    end
  end
end
