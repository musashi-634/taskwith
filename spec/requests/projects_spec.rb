require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "GET /projects" do
    let(:user) { create(:user) }
    let!(:undone_project) { create(:project, is_done: false) }

    before do
      sign_in user
      get projects_path
    end

    it 'プロジェクト情報を取得できること' do
      expect(response.body).to include undone_project.name
      expect(response.body).to include undone_project.description
    end

    it '表示中のプロジェクトの数量を取得できること' do
      expect(response.body).to include "#{Project.undone.count}件のプロジェクトを表示中"
    end
  end
end
