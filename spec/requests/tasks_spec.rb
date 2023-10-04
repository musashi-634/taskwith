require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /projects/:project_id/tasks" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let(:project) { create(:project, organization: organization) }
        let!(:task) do
          create(:task, start_at: '2023/7/1'.to_date, end_at: '2023/7/2'.to_date, project: project)
        end

        before { get project_tasks_path(project) }

        it 'タスク情報を取得できること' do
          expect(response.body).to include task.name
          expect(response.body).to include '2023/7/1'
          expect(response.body).to include '2023/7/2'
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

  describe "GET /projects/:project_id/tasks/new" do
    context 'ユーザーが組織に所属している場合' do
      let(:organization) { create(:organization, users: [user]) }
      let(:project) { create(:project, organization: organization) }

      before { get new_project_task_path(project) }

      it 'タスク作成ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '新規タスク作成'
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }

      before { get new_project_task_path(project) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "POST /projects/:project_id/tasks" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のプロジェクトの場合' do
        let(:project) { create(:project, organization: organization) }

        context '有効な属性値の場合' do
          let(:task_attributes) { attributes_for(:task) }

          it 'タスクを作成できること' do
            expect do
              post project_tasks_path(project), params: { task: task_attributes }
            end.to change { project.tasks.count }.by(1)
            expect(project.tasks.last.row_order).to be_truthy
          end
        end

        context '無効な属性値の場合' do
          let(:task_attributes) { attributes_for(:task, :invalid) }

          it 'タスクを作成できないこと' do
            expect do
              post project_tasks_path(project), params: { task: task_attributes }
            end.not_to change { project.tasks.count }
            expect(response).to have_http_status :unprocessable_entity
          end
        end
      end

      context '他の組織のプロジェクトの場合' do
        let(:project) { create(:project) }
        let(:task_attributes) { attributes_for(:task) }

        it 'タスクが作成されず、プロジェクト一覧ページにリダイレクトされること' do
          expect do
            post project_tasks_path(project), params: { task: task_attributes }
          end.not_to change { project.tasks.count }
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:project) { create(:project) }
      let(:task_attributes) { attributes_for(:task) }

      it 'タスクが作成されず、組織作成ページにリダイレクトされること' do
        expect do
          post project_tasks_path(project), params: { task: task_attributes }
        end.not_to change { project.tasks.count }
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "GET /tasks/:id" do
    context 'ユーザーが組織に所属している場合' do
      let(:project) { create(:project) }

      before { project.organization.users << user }

      context '所属組織のタスクの場合' do
        let(:task) { create(:task, project: project) }

        before { get task_path(task) }

        it 'タスク情報を取得できること' do
          expect(response.body).to include task.name
          expect(response).to have_http_status 200
        end
      end

      context '他の組織のタスクの場合' do
        let(:task) { create(:task) }

        before { get task_path(task) }

        it 'プロジェクト一覧ページにリダイレクトされること' do
          expect(response).to redirect_to projects_path
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:task) { create(:task) }

      before { get task_path(task) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
