require 'rails_helper'

RSpec.describe "Projects::Archives", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /projects/archives" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let!(:archived_project) { create(:project, :archived, organization: organization) }

        before { get projects_archives_path }

        it 'アーカイブ済みのプロジェクト名を取得できること' do
          expect(response.body).to include archived_project.name
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let!(:archived_project) { create(:project, :archived) }

        before { get projects_archives_path }

        it 'アーカイブ済みのプロジェクト名を取得できないこと' do
          expect(response.body).not_to include archived_project.name
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get projects_archives_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "POST /projects/archives" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let(:project) { create(:project, organization: organization) }
        let(:params) { { id: project.id } }

        it 'プロジェクトをアーカイブ化できること' do
          expect do
            post projects_archives_path, params: params
          end.to change { project.reload.is_archived }.from(false).to(true)
          expect(response).to redirect_to projects_path
        end
      end

      context '他の組織のプロジェクトの場合' do
        let(:project) { create(:project) }
        let(:params) { { id: project.id } }

        it 'プロジェクトをアーカイブ化できず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            post projects_archives_path, params: params
          end.not_to change { project.reload.is_archived }.from(false)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }
      let(:params) { { id: project.id } }

      it 'プロジェクトをアーカイブ化できず、組織作成ページにリダイレクトされること' do
        expect do
          post projects_archives_path, params: params
        end.not_to change { project.reload.is_archived }.from(false)
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "DELETE /projects/archives/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let(:archived_project) { create(:project, :archived, organization: organization) }

        it 'プロジェクトを非アーカイブ化できること' do
          expect do
            delete projects_archive_path(archived_project)
          end.to change { archived_project.reload.is_archived }.from(true).to(false)
          expect(response).to redirect_to projects_archives_path
        end
      end

      context '他の組織のプロジェクトの場合' do
        let(:archived_project) { create(:project, :archived) }

        it 'プロジェクトを非アーカイブ化できず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            delete projects_archive_path(archived_project)
          end.not_to change { archived_project.reload.is_archived }.from(true)
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:archived_project) { create(:project, :archived) }

      it 'プロジェクトを非アーカイブ化できず、組織作成ページにリダイレクトされること' do
        expect do
          delete projects_archive_path(archived_project)
        end.not_to change { archived_project.reload.is_archived }.from(true)
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
