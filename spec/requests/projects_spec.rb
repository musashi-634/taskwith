require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "GET /projects" do
    let(:user) { create(:user) }
    let!(:project) { create(:project) }

    before do
      sign_in user
      get projects_path
    end

    it 'プロジェクト情報を取得できること' do
      expect(response.body).to include project.name
      expect(response.body).to include project.description
    end

    xit '表示中のプロジェクトの数量を取得できること' do
      expect(response.body).to include "#{Project.count}件のプロジェクトを表示中"
    end
  end
end
