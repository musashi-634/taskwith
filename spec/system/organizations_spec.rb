require 'rails_helper'

RSpec.describe 'Organizations', type: :system do
  let(:user) { create(:user) }

  before { login_as(user, :scope => :user) }

  describe '組織作成機能' do
    let(:organization) { build(:organization) }

    it '組織を作成できること' do
      visit new_organization_path

      fill_in 'organization[name]', with: organization.name
      expect { click_on '作成' }.to change { Organization.count }.by(1)

      expect(current_path).to eq organization_path
      expect(page).to have_content '組織を作成しました。'
    end
  end

  describe '組織更新機能' do
    let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }
    let(:new_organization) { build(:custom_organization) }

    it '組織を更新できること' do
      visit organization_path
      click_on '編集'

      expect do
        fill_in 'organization[name]', with: new_organization.name
        click_on '更新'
      end.to change { organization.reload.name }.from(organization.name).to(new_organization.name)

      expect(current_path).to eq organization_path
      expect(page).to have_content '組織情報を更新しました。'
      expect(page).to have_content new_organization.name
    end
  end

  describe '組織設定ページ' do
    let!(:organization) { create(:organization, users: [user]) }

    before { visit organization_path }

    it '組織に関する情報が表示されていること' do
      within '.information' do
        expect(page).to have_content organization.name
      end

      within '.members' do
        expect(page).to have_content user.name
      end
    end
  end

  describe '組織メンバー更新機能' do
    let!(:organization) { Organization.create_with_admin(attributes_for(:organization), user) }
    let!(:other_member) { create(:user, organization: organization) }

    it 'メンバーの権限を更新できること' do
      visit organizations_member_path(other_member)
      click_on '変更'

      expect do
        check '管理者'
        click_on '更新'
      end.to change { other_member.reload.is_admin }.from(false).to(true)

      expect(current_path).to eq organization_path
      expect(page).to have_content '組織メンバーの権限を更新しました。'
    end
  end
end
