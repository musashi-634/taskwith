require 'rails_helper'

RSpec.describe 'Organizations', type: :system do
  let(:user) { create(:user) }

  before { login_as(user, :scope => :user) }

  describe '組織作成機能' do
    let(:organization) { build(:organization) }

    it '組織を作成できること' do
      visit new_organization_path

      fill_in 'organization[name]', with: organization.name
      expect { click_on '新規組織作成' }.to change { Organization.count }.by(1)

      expect(current_path).to eq organization_path
      expect(page).to have_content '組織を作成しました。'
    end
  end

  describe '組織設定ページ' do
    let!(:organization) { create(:organization, users: [user]) }

    before { visit organization_path }

    it '組織に関する情報が表示されていること' do
      within '.information' do
        expect(page).to have_content organization.id
        expect(page).to have_content organization.name
      end

      within '.members' do
        expect(page).to have_content user.name
      end
    end
  end
end
