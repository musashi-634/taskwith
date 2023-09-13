require 'rails_helper'

RSpec.describe "Users::Invitations", type: :request do
  describe "GET /users/invitation/new" do
    let(:user) { create(:user) }

    before { sign_in user }

    context 'ユーザーが組織に所属している場合' do
      before do
        create(:organization, users: [user])
        get new_user_invitation_path
      end

      it 'ユーザー招待作成ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '招待する'
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get new_user_invitation_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "POST /users/invitation" do
    let(:user) { create(:user) }

    before { sign_in user }

    context 'ユーザーが組織に所属している場合' do
      before { create(:organization, users: [user]) }

      context '有効な属性値の場合' do
        let(:user_attributes) { attributes_for(:user).slice(:email) }

        it '招待メールを送信できること' do
          expect do
            post user_invitation_path, params: { user: user_attributes }
          end.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it '招待メールの宛先と件名が適切なこと' do
          post user_invitation_path, params: { user: user_attributes }
          invitation_mail = ActionMailer::Base.deliveries.last

          expect(invitation_mail.to).to eq [user_attributes[:email]]
          expect(invitation_mail.subject).to eq(
            "[TaskWith] #{user.name}さんから、「#{user.organization.name}」という組織に招待されました"
          )
        end

        it '招待されたユーザーに所望の属性値が設定されること' do
          post user_invitation_path, params: { user: user_attributes }

          expect(User.last.email).to eq user_attributes[:email]
          expect(User.last.invited_by).to eq user
        end
      end

      context '無効な属性値の場合' do
        let(:user_attributes) { attributes_for(:user, :invalid).slice(:email) }

        it '招待メールを送信できないこと' do
          expect do
            post user_invitation_path, params: { user: user_attributes }
          end.not_to change { ActionMailer::Base.deliveries.size }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:user_attributes) { attributes_for(:user).slice(:email) }

      it '招待メールが送信されず、組織作成ページにリダイレクトされること' do
        expect do
          post user_invitation_path, params: { user: user_attributes }
        end.not_to change { ActionMailer::Base.deliveries.size }
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
