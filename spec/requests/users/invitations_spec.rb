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

  describe "GET /users/invitation/accept" do
    let(:user) { User.invite!(email: build(:user).email, skip_invitation: true) }

    context 'URLパラメータに有効なinvitation_tokenが含まれる場合' do
      before { get accept_user_invitation_path(invitation_token: user.raw_invitation_token) }

      it 'ユーザー招待承認ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include 'パスワードを設定する'
      end
    end

    context 'URLパラメータに有効なinvitation_tokenが含まれない場合' do
      before { get accept_user_invitation_path }

      it 'ルートパスにリダイレクトされること' do
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq '招待コードが不正です。'
      end
    end
  end

  describe "PATCH /users/invitation" do
    let(:user) { create(:user, :with_organization) }
    let!(:invitee) { User.invite!({ email: build(:user).email, skip_invitation: true }, user) }

    before { patch user_invitation_path, params: { user: user_attributes } }

    context 'URLパラメータに有効なinvitation_tokenが含まれる場合' do
      context '有効な属性値の場合' do
        let(:user_attributes) do
          attributes_for(:user).slice(:name, :password, :password_confirmation).
            merge({
              organization_id: user.organization.id,
              invitation_token: invitee.raw_invitation_token,
            })
        end

        it '招待された組織に参加できること' do
          expect { invitee.reload }.to change { invitee.organization }.from(nil).to(user.organization)
        end

        it 'ユーザー名が設定されること' do
          expect { invitee.reload }.to change { invitee.name }.from(nil).to(user_attributes[:name])
        end

        it 'パスワードが設定されること' do
          expect { invitee.reload }.to change {
            invitee.valid_password?(user_attributes[:password])
          }.from(nil).to(true)
        end
      end

      context '無効な属性値の場合' do
        let(:user_attributes) do
          attributes_for(:user, :invalid).slice(:name, :password, :password_confirmation).
            merge({
              organization_id: user.organization.id,
              invitation_token: invitee.raw_invitation_token,
            })
        end

        it '招待された組織に参加できないこと' do
          expect { invitee.reload }.not_to change { invitee.organization }.from(nil)
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'URLパラメータに有効なinvitation_tokenが含まれない場合' do
      let(:user_attributes) do
        attributes_for(:user).slice(:name, :password, :password_confirmation).
          merge({ organization_id: user.organization.id })
      end

      it '招待された組織に参加できないこと' do
        expect { invitee.reload }.not_to change { invitee.organization }.from(nil)
      end

      it 'ユーザー名が設定されないこと' do
        expect { invitee.reload }.not_to change { invitee.name }.from(nil)
      end

      it 'パスワードが設定されないこと' do
        expect { invitee.reload }.not_to change {
          invitee.valid_password?(user_attributes[:password])
        }.from(nil)
      end
    end
  end
end