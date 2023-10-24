require 'rails_helper'

RSpec.describe "Organizations::Members", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  # show
  describe "GET /organizations/members/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のメンバーを指定した場合' do
        let(:other_user) { create(:user, organization: organization) }

        before { get organizations_member_path(other_user) }

        it '組織メンバーの情報を取得できること' do
          expect(response).to have_http_status 200
          expect(response.body).to include other_user.name
          expect(response.body).to include other_user.email
          expect(response.body).to include other_user.display_admin_privilege
        end
      end

      context '所属組織のメンバー以外を指定した場合' do
        let(:other_user) { create(:user, :with_organization) }

        it 'エラーが発生すること' do
          expect do
            get organizations_member_path(other_user)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:other_user) { create(:user, :with_organization) }

      before { get organizations_member_path(other_user) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # edit
  describe "GET /organizations/members/:id/edit" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のメンバーを指定した場合' do
        let(:other_user) { create(:user, organization: organization) }

        before { get edit_organizations_member_path(other_user) }

        it '組織メンバー詳細ページにアクセスできること' do
          expect(response).to have_http_status 200
          expect(response.body).to include other_user.name
          expect(response.body).to include other_user.email
        end
      end

      context '所属組織のメンバー以外を指定した場合' do
        let(:other_user) { create(:user, :with_organization) }

        it 'エラーが発生すること' do
          expect do
            get edit_organizations_member_path(other_user)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:other_user) { create(:user, :with_organization) }

      before { get edit_organizations_member_path(other_user) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # update
  describe "PATCH /organizations/members/:id" do
    context 'ユーザーが組織に所属している場合' do
      context '管理者の場合' do
        let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }

        context '所属組織の自分以外のメンバーを指定した場合' do
          let!(:other_user) { create(:user, organization: organization) }

          context '有効な属性値の場合' do
            let(:user_attributes) { { is_admin: true } }

            it '権限を変更できること' do
              expect do
                patch organizations_member_path(other_user), params: { user: user_attributes }
              end.to change { other_user.reload.is_admin }.from(false).to(true)
            end
          end

          context '無効な属性値の場合' do
            let(:user_attributes) { { is_admin: nil } }

            it '権限を変更できないこと' do
              expect do
                patch organizations_member_path(other_user), params: { user: user_attributes }
              end.not_to change { other_user.reload.is_admin }.from(false)
              expect(response).to have_http_status :unprocessable_entity
            end
          end
        end

        context '自分自身を指定した場合' do
          let(:user_attributes) { { is_admin: false } }

          it '権限を変更できず、プロジェクト一覧ページにリダイレクトされること' do
            expect do
              patch organizations_member_path(user), params: { user: user_attributes }
            end.not_to change { user.reload.is_admin }.from(true)
            expect(response).to redirect_to projects_path
          end
        end

        context '所属組織のメンバー以外を指定した場合' do
          let!(:other_user) { create(:user, :with_organization) }
          let(:user_attributes) { { is_admin: true } }

          it 'エラーが発生すること' do
            expect do
              patch organizations_member_path(other_user), params: { user: user_attributes }
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context '一般ユーザーの場合' do
        let!(:organization) { create(:organization, users: [user]) }
        let!(:other_user) { create(:user, organization: organization) }
        let(:user_attributes) { { is_admin: true } }

        it '権限を変更できず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            patch organizations_member_path(other_user), params: { user: user_attributes }
          end.not_to change { other_user.reload.is_admin }.from(false)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:other_user) { create(:user, :with_organization) }
      let(:user_attributes) { { is_admin: true } }

      it '権限を変更できず、組織作成ページにリダイレクトされること' do
        expect do
          patch organizations_member_path(other_user), params: { user: user_attributes }
        end.not_to change { other_user.reload.is_admin }.from(false)
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # destroy
  describe "DELETE /organizations/members/:id" do
    context 'ユーザーが組織に所属している場合' do
      context '管理者の場合' do
        let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }

        context '所属組織の自分以外のメンバーを指定した場合' do
          let!(:other_user) { create(:user, organization: organization) }

          before do
            project = create(:project, organization: organization.reload, users: [other_user])
            create(:task, project: project, users: [other_user])
          end

          it '組織メンバーを脱退させられること' do
            expect do
              delete organizations_member_path(other_user)
            end.to change { organization.reload.users.count }.by(-1)
          end

          it 'プロジェクトメンバーから情報が削除されること' do
            expect do
              delete organizations_member_path(other_user)
            end.to change { other_user.reload.projects.count }.by(-1)
          end

          it 'タスク担当者から情報が削除されること' do
            expect do
              delete organizations_member_path(other_user)
            end.to change { other_user.reload.tasks.count }.by(-1)
          end
        end

        context '自分自身を指定した場合' do
          it '組織を脱退できず、プロジェクト一覧ページにリダイレクトされること' do
            expect do
              delete organizations_member_path(user)
            end.not_to change { organization.reload.users.count }
            expect(response).to redirect_to projects_path
          end
        end

        context '所属組織のメンバー以外を指定した場合' do
          let!(:other_user) { create(:user, :with_organization) }

          it 'エラーが発生すること' do
            expect do
              delete organizations_member_path(other_user)
            end.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context '一般ユーザーの場合' do
        let!(:organization) { create(:organization, users: [user]) }
        let!(:other_user) { create(:user, organization: organization) }

        it '組織メンバーを脱退させられず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            delete organizations_member_path(other_user)
          end.not_to change { organization.reload.users.count }
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:organization) { create(:organization) }
      let!(:other_user) { create(:user, organization: organization) }

      it '組織メンバーを脱退させられず、組織作成ページにリダイレクトされること' do
        expect do
          delete organizations_member_path(other_user)
        end.not_to change { organization.reload.users.count }
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
