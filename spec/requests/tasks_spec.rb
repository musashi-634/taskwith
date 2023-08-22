require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /projects/:project_id/tasks" do
    let(:user) { create(:user) }

    before { sign_in user }

    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let(:project) { create(:project, organization: organization) }
        let!(:task) { create(:task, project: project) }

        before { get project_tasks_path(project) }

        it 'タスク情報を取得できること' do
          expect(response.body).to include task.name
          expect(response.body).to include task.start_at.to_fs(:date)
          expect(response.body).to include task.end_at.to_fs(:date)
        end
      end

      context '他の組織のプロジェクトの場合' do
        let(:project) { create(:project) }

        before { get project_tasks_path(project) }

        it 'プロジェクト一覧ページにリダイレクトされること' do
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }

      before { get project_tasks_path(project) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
