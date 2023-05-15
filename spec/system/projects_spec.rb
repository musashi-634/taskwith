require 'rails_helper'

RSpec.describe 'Projects', type: :system do
  let(:user) { create(:user) }

  before { login_as(user, :scope => :user) }

  describe 'プロジェクト登録機能' do
    let(:project) { build(:project) }

    it 'プロジェクト登録を正常に行えること' do
      visit new_project_path

      fill_in 'project[name]', with: project.name
      expect { click_on '作成' }.to change { Project.count }.by(1)

      expect(current_path).to eq projects_path
      expect(page).to have_content 'プロジェクトを作成しました。'
    end
  end

  describe 'プロジェクト一覧ページ' do
    let!(:project) { create(:project) }

    before { visit projects_path }

    describe 'ハンバーガーメニュー' do
      xit 'プロジェクト名が表示されていること' do
        within '.offcanvas' do
          expect(page).to have_content project.name
        end
      end
    end

    describe 'メインコンテンツ' do
      it 'プロジェクトの情報が表示されていること' do
        within 'main' do
          expect(page).to have_content project.name
          expect(page).to have_content project.description
        end
      end
    end
  end
end
