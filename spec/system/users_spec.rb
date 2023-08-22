require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ヘッダー' do
    context 'ログアウトしている場合' do
      before { visit root_path }

      it 'ハンバーガーメニューが表示されていないこと' do
        expect(page).not_to have_css '.navbar-toggler'
      end

      it 'ログインや新規登録のリンクが表示されていること' do
        within 'header' do
          expect(page).to have_content 'ログイン'
          expect(page).to have_content 'ゲストログイン'
          expect(page).to have_content '新規登録'
        end
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        login_as(user, :scope => :user)
        visit root_path
      end

      it 'ハンバーガーメニューが表示されていること' do
        expect(page).to have_css '.navbar-toggler'
      end

      it 'ユーザー名が表示されていること' do
        within 'header' do
          expect(page).to have_content user.name
        end
      end
    end
  end

  describe 'ログイン機能' do
    let(:user) { create(:user, :with_organization) }

    it 'ログイン後にプロジェクト一覧ページに遷移し、ログインメッセージが表示されること' do
      visit new_user_session_path

      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      within 'form' do
        click_on 'ログイン'
      end

      expect(current_path).to eq projects_path
      expect(page).to have_content 'ログインしました。'
    end
  end

  describe 'ログアウト機能' do
    let(:user) { create(:user, :with_organization) }

    before do
      login_as(user, :scope => :user)
      visit projects_path
    end

    it 'ログアウト後にルートパスに遷移し、ログアウトメッセージが表示されること' do
      within 'header' do
        click_on user.name
        click_on 'ログアウト'
      end

      expect(current_path).to eq root_path
      expect(page).to have_content 'ログアウトしました。'
    end
  end

  describe 'ユーザー登録機能' do
    let(:user) { build(:user) }

    it 'ユーザー登録後に組織作成ページに遷移し、登録完了メッセージが表示されること' do
      visit new_user_registration_path

      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password
      within 'form' do
        click_on 'アカウント登録'
      end

      expect(current_path).to eq new_organization_path
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end
end
