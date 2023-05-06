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

  describe 'ログイン機能'
  describe '新規登録機能'
end
