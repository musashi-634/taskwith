require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /projects" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let!(:project) { create(:project, is_archived: false, organization: organization) }

        before { get projects_path }

        it 'プロジェクト情報を取得できること' do
          expect(response).to have_http_status 200
          expect(response.body).to include project.name
        end

        it '表示中のプロジェクトの数量を取得できること' do
          expect(response.body).
            to include "#{organization.projects.where(is_archived: false).count}件のプロジェクトを表示中"
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let!(:project) { create(:project, is_archived: false) }

        before { get projects_path }

        it 'プロジェクト情報を取得できないこと' do
          expect(response.body).not_to include project.name
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get projects_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "GET /projects/new" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get new_project_path }

      it 'プロジェクト作成ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '新規プロジェクト作成'
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get new_project_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "POST /projects" do
    context 'ユーザーが組織に所属している場合' do
      before { create(:organization, users: [user]) }

      context '有効な属性値の場合' do
        let(:project_attributes) { attributes_for(:project).merge({ user_ids: [user.id] }) }

        it '所属組織のプロジェクトを作成できること' do
          expect do
            post projects_path, params: { project: project_attributes }
          end.to change { user.organization.projects.count }.by(1)
          expect(user.organization.projects.last.users).to eq [user]
        end
      end

      context '無効な属性値の場合' do
        let(:project_attributes) do
          attributes_for(:project, :invalid).merge({ user_ids: [user.id] })
        end

        it '所属組織のプロジェクトを作成できないこと' do
          expect do
            post projects_path, params: { project: project_attributes }
          end.not_to change { user.organization.projects.count }
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project_attributes) { attributes_for(:project).merge({ user_ids: [user.id] }) }

      it 'プロジェクトが作成されず、組織作成ページにリダイレクトされること' do
        expect do
          post projects_path, params: { project: project_attributes }
        end.not_to change { Project.count }
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "GET /projects/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let(:project) { create(:project, organization: organization) }

        before { get project_path(project) }

        it 'プロジェクト情報を取得できること' do
          expect(response).to have_http_status 200
          expect(response.body).to include project.name
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let(:project) { create(:project) }

        before { get project_path(project) }

        it 'プロジェクト一覧ページにリダイレクトされること' do
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }

      before { get project_path(project) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "GET /projects/:id/edit" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let(:project) { create(:project, organization: organization) }

        before { get edit_project_path(project) }

        it 'プロジェクト編集ページにアクセスできること' do
          expect(response).to have_http_status 200
          expect(response.body).to include 'プロジェクト編集'
          expect(response.body).to include project.name
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let(:project) { create(:project) }

        before { get edit_project_path(project) }

        it 'プロジェクト一覧ページにリダイレクトされること' do
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }

      before { get edit_project_path(project) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "PATCH /projects/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let(:project) { create(:project, organization: organization) }

        context '有効な属性値の場合' do
          let(:project_attributes) { attributes_for(:custom_project) }

          it 'プロジェクト情報を更新できること' do
            expect do
              patch project_path(project), params: { project: project_attributes }
            end.to change { project.reload.name }.from(project.name).to(project_attributes[:name])
          end

          it 'メンバーを更新できること' do
            expect do
              patch(
                project_path(project),
                params: { project: project_attributes.merge(user_ids: [user.id]) }
              )
            end.to change { project.reload.user_ids }.from([]).to([user.id])
          end
        end

        context '無効な属性値の場合' do
          let(:project_attributes) { attributes_for(:project, :invalid) }

          it 'プロジェクト情報を更新できないこと' do
            expect do
              patch project_path(project), params: { project: project_attributes }
            end.not_to change { project.reload.name }.from(project.name)
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let(:project) { create(:project) }
        let(:project_attributes) { attributes_for(:custom_project) }

        it 'プロジェクト情報が更新されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            patch project_path(project), params: { project: project_attributes }
          end.not_to change { project.reload.name }.from(project.name)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }
      let(:project_attributes) { attributes_for(:custom_project) }

      it 'プロジェクト情報が更新されず、組織作成ページにリダイレクトされること' do
        expect do
          patch project_path(project), params: { project: project_attributes }
        end.not_to change { project.reload.name }.from(project.name)
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "DELETE /projects/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let!(:project) { create(:project, organization: organization) }

        it 'プロジェクトを削除できること' do
          expect do
            delete project_path(project)
          end.to change { Project.count }.by(-1)
          expect(response).to redirect_to projects_archives_path
        end
      end

      context '他の組織のプロジェクトの場合' do
        let!(:project) { create(:project) }

        it 'プロジェクトが削除されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            delete project_path(project)
          end.not_to change { Project.count }
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let!(:project) { create(:project) }

      it 'プロジェクトが削除されず、組織作成ページにリダイレクトされること' do
        expect do
          delete project_path(project)
        end.not_to change { Project.count }
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
