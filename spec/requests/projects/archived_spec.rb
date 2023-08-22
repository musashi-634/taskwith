require 'rails_helper'

RSpec.describe "Projects::Archived", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /projects/archived" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context 'プロジェクトが所属組織のものである場合' do
        let!(:archived_project) { create(:project, :archived, organization: organization) }

        before { get projects_archived_index_path }

        it 'アーカイブ済みのプロジェクト名を取得できること' do
          expect(response.body).to include archived_project.name
        end
      end

      context 'プロジェクトが他の組織のものである場合' do
        let!(:archived_project) { create(:project, :archived) }

        before { get projects_archived_index_path }

        it 'アーカイブ済みのプロジェクト名を取得できないこと' do
          expect(response.body).not_to include archived_project.name
        end
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
