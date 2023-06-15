require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "GET /projects" do
    let(:user) { create(:user) }
    let!(:project) { create(:project, is_archived: false) }

    before do
      sign_in user
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

  describe "GET /projects/archived" do
    let(:user) { create(:user) }
    let!(:archived_project) { create(:project, :archived) }

    before do
      sign_in user
      get projects_archived_index_path
    end

    it 'アーカイブ済みのプロジェクト名を取得できること' do
      expect(response.body).to include archived_project.name
    end
  end
end
