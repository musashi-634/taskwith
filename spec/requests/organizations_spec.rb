require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  # show
  describe "GET /organization" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get organization_path }

      it '組織情報を取得できること' do
        expect(response.body).to include organization.id.to_s
        expect(response.body).to include organization.name
      end

      it '組織メンバーを取得できること' do
        expect(response.body).to include user.name
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get organization_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # new
  describe "GET /organization/new" do
    context 'ユーザーが組織に所属していない場合' do
      before { get new_organization_path }

      it '組織作成ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '新規組織作成'
      end
    end

    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get new_organization_path }

      it '組織詳細ページにリダイレクトされること' do
        expect(response).to redirect_to organization_path
        expect(flash[:alert]).to eq 'すでに組織に所属しています。'
      end
    end
  end

  # create
  describe "POST /organization" do
    context 'ユーザーが組織に所属していない場合' do
      context '有効な属性値の場合' do
        let(:organization_attributes) { attributes_for(:organization) }

        it '組織を作成できること' do
          expect do
            post organization_path, params: { organization: organization_attributes }
          end.to change { Organization.count }.by(1)
          expect(Organization.last.users).to eq [user]
        end

        it '作成者が管理者になること' do
          expect do
            post organization_path, params: { organization: organization_attributes }
          end.to change { user.reload.is_admin? }.from(false).to(true)
        end
      end

      context '無効な属性値の場合' do
        let(:organization_attributes) { attributes_for(:organization, :invalid) }

        it '組織を作成できないこと' do
          expect do
            post organization_path, params: { organization: organization_attributes }
          end.not_to change { Organization.count }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'ユーザーが組織に所属している場合' do
      let(:organization_attributes) { attributes_for(:organization) }

      before { create(:organization, users: [user]) }

      it '組織が作成されず、組織詳細ページにリダイレクトされること' do
        expect do
          post organization_path, params: { organization: organization_attributes }
        end.not_to change { Organization.count }
        expect(response).to redirect_to organization_path
      end
    end
  end

  # edit
  describe "GET /organization/edit" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get edit_organization_path }

      it '組織編集ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '組織編集'
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get edit_organization_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # update
  describe "PATCH /organization" do
    context 'ユーザーが組織に所属している場合' do
      context '管理者の場合' do
        let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }

        context '有効な属性値の場合' do
          let(:organization_attributes) { attributes_for(:custom_organization) }

          it '組織を更新できること' do
            expect do
              patch organization_path, params: { organization: organization_attributes }
            end.to change {
              organization.reload.name
            }.from(organization.name).to(organization_attributes[:name])
          end
        end

        context '無効な属性値の場合' do
          let(:organization_attributes) { attributes_for(:organization, :invalid) }

          it '組織を更新できないこと' do
            expect do
              patch organization_path, params: { organization: organization_attributes }
            end.not_to change { organization.reload.name }.from(organization.name)
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context '管理者でない場合' do
        let!(:organization) { create(:organization, users: [user]) }
        let(:organization_attributes) { attributes_for(:custom_organization) }

        it '組織が更新されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            patch organization_path, params: { organization: organization_attributes }
          end.not_to change { organization.reload.name }.from(organization.name)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:organization) { create(:organization) }
      let(:organization_attributes) { attributes_for(:custom_organization) }

      it '組織が更新されず、組織作成ページにリダイレクトされること' do
        expect do
          patch organization_path, params: { organization: organization_attributes }
        end.not_to change { organization.reload.name }.from(organization.name)
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  # destroy
  describe "DELETE /organization" do
    context 'ユーザーが組織に所属している場合' do
      context '管理者の場合' do
        let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }

        it '組織を削除できること' do
          expect do
            delete organization_path
          end.to change { Organization.count }.by(-1)
        end
      end

      context '管理者でない場合' do
        let!(:organization) { create(:organization, users: [user]) }

        it '組織が削除されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            delete organization_path
          end.not_to change { Organization.count }
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:organization) { create(:organization) }

      it '組織が削除されず、組織作成ページにリダイレクトされること' do
        expect do
          delete organization_path
        end.not_to change { Organization.count }
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
