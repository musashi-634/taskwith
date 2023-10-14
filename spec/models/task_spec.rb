require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:project) { create(:project) }

    it 'プロジェクトメンバーだけを許可する' do
      project_member = create(:user, organization: project.organization, projects: [project])
      task = build(:task, project: project.reload, users: [project_member])
      expect(task).to be_valid

      not_project_member = create(:user)
      task.users = [not_project_member]
      expect(task).to be_invalid
    end
  end
end
