require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /projects/:project_id/tasks" do
    let(:user) { create(:user) }
    let(:task) { create(:task) }

    before do
      sign_in user
      get project_tasks_path(task.project)
    end

    it 'タスク情報を取得できること' do
      expect(response.body).to include task.name
      expect(response.body).to include task.start_at.to_fs(:date)
      expect(response.body).to include task.end_at.to_fs(:date)
    end
  end
end
