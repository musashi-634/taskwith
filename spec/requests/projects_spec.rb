require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /projects" do
    context 'ユーザーが組織に所属している場合' do
      let(:project) { create(:project, is_archived: false) }

      before do
        project.organization.users << user
        get projects_path
      end

      it 'プロジェクト情報を取得できること' do
        expect(response.body).to include project.name
        expect(response.body).to include project.description
      end

      it '表示中のプロジェクトの数量を取得できること' do
        expect(response.body).to include "#{Project.where(is_archived: false).count}件のプロジェクトを表示中"
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

  describe "GET /projects/archived" do
    context 'ユーザーが組織に所属している場合' do
      let(:archived_project) { create(:project, :archived) }

      before do
        archived_project.organization.users << user
        get projects_archived_index_path
      end

      it 'アーカイブ済みのプロジェクト名を取得できること' do
        expect(response.body).to include archived_project.name
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get projects_archived_index_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
