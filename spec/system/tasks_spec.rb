require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user, :with_organization) }

  before { login_as(user, :scope => :user) }

  describe 'プロジェクトタスク一覧ページ' do
    let(:project) { create(:project, organization: user.organization) }

    describe 'プロジェクト' do
      before { visit project_tasks_path(project) }

      it '指定したプロジェクト名が表示されていること' do
        within 'main' do
          expect(page).to have_content project.name
        end
      end
    end

    describe 'タスク' do
      describe 'ガントバー' do
        context 'タスク期間が指定されている場合' do
          let!(:task) { create(:task_with_time_span, project: project) }

          before { visit project_tasks_path(project) }

          it '表示されていること' do
            expect(find('.gantt-bar')).to be_visible
          end
        end

        context 'タスク期間が欠落している場合' do
          let!(:task) { create(:task, project: project) }

          before { visit project_tasks_path(project) }

          it '非表示になっていること' do
            expect(find('.gantt-bar', visible: false)).not_to be_visible
          end
        end
      end

      describe '完了状態' do
        let!(:task) { create(:task, :done, project: project) }

        before { visit project_tasks_path(project) }

        it '完了タスクがグレーアウトされていること' do
          within '.gantt-tasks' do
            expect(page).to have_css '.done-task'
          end
        end
      end
    end
  end

  describe 'タスク登録機能' do
    let(:project) { create(:project, organization: user.organization) }
    let(:task) { build(:task) }

    it 'タスクを登録できること' do
      visit project_tasks_path(project)
      click_on '+'

      expect(current_path).to eq new_project_task_path(project)

      expect do
        fill_in 'task[name]', with: task.name
        click_on '作成'
      end.to change { project.tasks.count }.by(1)

      expect(current_path).to eq project_tasks_path(project)
      expect(page).to have_content 'タスクを作成しました。'
      expect(page).to have_content task.name
    end
  end
end
