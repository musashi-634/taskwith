require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    context 'ログインしていない場合' do
      before { get new_user_registration_path }

      it 'ユーザー登録ページに遷移できること' do
        expect(response).to have_http_status 200
        expect(response.body).to include 'アカウント登録'
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get new_user_registration_path
      end

      it 'プロジェクト一覧ページにリダイレクトされること' do
        expect(response).to redirect_to projects_path
      end
    end
  end

  describe "GET /users/edit" do
    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get edit_user_registration_path
      end

      it 'アカウント編集ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include 'アカウント編集'
        expect(response.body).to include user.name
        expect(response.body).to include user.email
      end
    end

    context 'ログインしていない場合' do
      before { get edit_user_registration_path }

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe "PATCH /users" do
    context 'ログインしている場合' do
      context '通常ユーザーの場合' do
        let!(:user) { create(:user) }

        before { sign_in user }

        context 'パスワードを更新しない場合' do
          context '有効な属性値の場合' do
            let(:user_attributes) do
              attributes_for(:custom_user).slice(:name, :email).
                merge({ current_password: user.password })
            end

            it 'ユーザー名を更新できること' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.to change { user.reload.name }.from(user.name).to(user_attributes[:name])
            end

            it 'メールアドレスを更新できること' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.to change { user.reload.email }.from(user.email).to(user_attributes[:email])
            end
          end

          context '無効な属性値の場合' do
            let(:user_attributes) do
              attributes_for(:user, :invalid).slice(:name, :email).
                merge({ current_password: user.password })
            end

            it 'アカウント情報を更新できないこと' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.not_to change { user.reload.name }.from(user.name)
              expect(response).to have_http_status :unprocessable_entity
            end
          end

          context '現在のパスワードが未入力の場合' do
            let(:user_attributes) { attributes_for(:custom_user).slice(:name, :email) }

            it 'アカウント情報を更新できないこと' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.not_to change { user.reload.name }.from(user.name)
              expect(response).to have_http_status :unprocessable_entity
            end
          end
        end

        context 'パスワードを更新する場合' do
          context '有効な属性値の場合' do
            let(:user_attributes) do
              attributes_for(:custom_user).merge({ current_password: user.password })
            end

            it 'パスワードを更新できること' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.to change {
                user.reload.valid_password?(user_attributes[:password])
              }.from(false).to(true)
            end
          end

          context '無効な属性値の場合' do
            let(:user_attributes) do
              attributes_for(:custom_user, password: 'aaaaaa', password_confirmation: 'bbbbbb').
                merge({ current_password: user.password })
            end

            it 'パスワードを更新できないこと' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.not_to change {
                user.reload.valid_password?(user_attributes[:password])
              }.from(false)
              expect(response).to have_http_status :unprocessable_entity
            end
          end

          context '現在のパスワードが未入力の場合' do
            let(:user_attributes) { attributes_for(:custom_user) }

            it 'パスワードを更新できないこと' do
              expect do
                patch user_registration_path, params: { user: user_attributes }
              end.not_to change {
                user.reload.valid_password?(user_attributes[:password])
              }.from(false)
              expect(response).to have_http_status :unprocessable_entity
            end
          end
        end
      end

      context 'ゲストユーザーの場合' do
        let!(:guest_user) { create(:guest_user) }
        let(:user_attributes) do
          attributes_for(:custom_user).slice(:name, :email).
            merge({ current_password: guest_user.password })
        end

        before { sign_in guest_user }

        it 'アカウント情報が更新されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            patch user_registration_path, params: { user: user_attributes }
          end.not_to change { guest_user.reload.name }.from(guest_user.name)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ログインしていない場合' do
      let!(:user) { create(:user) }
      let(:user_attributes) do
        attributes_for(:custom_user).slice(:name, :email).
          merge({ current_password: user.password })
      end

      it 'アカウント情報が更新されず、ログインページにリダイレクトされること' do
        expect do
          patch user_registration_path, params: { user: user_attributes }
        end.not_to change { user.reload.name }.from(user.name)
        expect(response).to redirect_to user_session_path
      end
    end
  end

  describe "DELETE /users" do
    context 'ログインしている場合' do
      context '通常ユーザーの場合' do
        let!(:user) { create(:user) }

        before { sign_in user }

        context '組織に所属している場合' do
          context '管理者ユーザーの場合' do
            let!(:organization) do
              Organization.create_with_admin(attributes_for(:organization), user)
            end

            context '組織の管理者が自分1人の場合' do
              it 'ユーザーが削除されること' do
                expect do
                  delete user_registration_path
                end.to change { User.count }.by(-1)
                expect(response).to redirect_to root_path
              end

              it '所属組織が削除されること' do
                expect do
                  delete user_registration_path
                end.to change { Organization.count }.by(-1)
              end
            end

            context '組織の管理者が複数の場合' do
              before { organization.users << create(:user, :admin) }

              it 'ユーザーが削除されること' do
                expect do
                  delete user_registration_path
                end.to change { User.count }.by(-1)
                expect(response).to redirect_to root_path
              end

              it '所属組織が削除されないこと' do
                expect do
                  delete user_registration_path
                end.not_to change { Organization.count }
              end
            end
          end

          context '一般ユーザーの場合' do
            let!(:organization) { create(:organization, users: [user]) }

            before { organization.users << create(:user, :admin) }

            it 'ユーザーが削除されること' do
              expect do
                delete user_registration_path
              end.to change { User.count }.by(-1)
              expect(response).to redirect_to root_path
            end

            it '所属組織が削除されないこと' do
              expect do
                delete user_registration_path
              end.not_to change { Organization.count }
            end
          end
        end

        context '組織に所属していない場合' do
          it 'ユーザーが削除されること' do
            expect do
              delete user_registration_path
            end.to change { User.count }.by(-1)
            expect(response).to redirect_to root_path
          end
        end
      end

      context 'ゲストユーザーの場合' do
        let!(:guest_user) { create(:guest_user) }

        before { sign_in guest_user }

        it 'ユーザーが削除されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            delete user_registration_path
          end.not_to change { User.count }
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ログインしていない場合' do
      let!(:user) { create(:user) }

      it 'ユーザーが削除されず、ログインページにリダイレクトされること' do
        expect do
          delete user_registration_path
        end.not_to change { User.count }
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
