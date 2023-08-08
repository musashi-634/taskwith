require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user, :with_organization) }

  before { login_as(user, :scope => :user) }

  describe 'プロジェクトタスク一覧ページ' do
    describe 'プロジェクト情報' do
      let(:project) { create(:project) }

      before do
        visit project_tasks_path(project)
      end

      it '指定したプロジェクト名が表示されていること' do
        within 'main' do
          expect(page).to have_content project.name
        end
      end
    end

    describe 'タスク情報' do
      let(:task) { create(:task, :done) }

      before do
        visit project_tasks_path(task.project)
      end

      it '完了タスクがグレーアウトされていること' do
        within '.gantt-tasks' do
          expect(page).to have_css '.done-task'
        end
      end
    end
  end
end
