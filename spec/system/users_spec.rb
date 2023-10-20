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
    context '一般ユーザーの場合' do
      let(:user) { create(:user, :with_organization) }

      it 'ログイン後にプロジェクト一覧ページに遷移し、ログインメッセージが表示されること' do
        visit new_user_session_path

        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        within '.new_user' do
          click_on 'ログイン'
        end

        expect(current_path).to eq projects_path
        expect(page).to have_content 'ログインしました。'
      end
    end

    context 'ゲストユーザーの場合' do
      let!(:guest_user) { create(:guest_user, :with_organization) }

      it 'ログイン後にプロジェクト一覧ページに遷移し、ログインメッセージが表示されること' do
        visit home_index_path
        click_on 'ゲストログイン'

        expect(current_path).to eq projects_path
        expect(page).to have_content 'ゲストユーザーとしてログインしました。'
      end
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
      fill_in 'user[password_confirmation]', with: user.password_confirmation
      within '.new_user' do
        click_on 'アカウント登録'
      end

      expect(current_path).to eq new_organization_path
      expect(page).to have_content 'アカウント登録が完了しました。'
    end
  end

  describe 'ユーザー更新機能' do
    let(:user) { create(:user) }
    let(:new_user) { build(:custom_user) }

    before { login_as(user, :scope => :user) }

    it 'ユーザー名とメールアドレスを更新できること' do
      visit edit_user_registration_path

      expect do
        fill_in 'user[name]', with: new_user.name
        fill_in 'user[email]', with: new_user.email
        fill_in 'user[current_password]', with: user.password
        click_on '更新'
      end.to change { user.reload.name }.from(user.name).to(new_user.name)

      expect(user.email).to eq new_user.email
      expect(current_path).to eq users_account_path
      expect(page).to have_content 'アカウント情報を変更しました。'
    end

    it 'パスワードを更新できること' do
      visit edit_user_registration_path

      expect do
        fill_in 'user[name]', with: user.name
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: new_user.password
        fill_in 'user[password_confirmation]', with: new_user.password_confirmation
        fill_in 'user[current_password]', with: user.password
        click_on '更新'
      end.to change { user.reload.valid_password?(new_user.password) }.from(false).to(true)

      expect(current_path).to eq users_account_path
      expect(page).to have_content 'アカウント情報を変更しました。'
    end
  end

  describe 'ユーザー招待機能' do
    let(:user) { create(:user, :with_organization, :admin) }

    before { login_as(user, :scope => :user) }

    context '新規ユーザーを招待する場合' do
      let(:invitee) { build(:user) }

      it '招待メールが送信され、メール内のリンクから組織に参加できること' do
        # 組織への招待
        visit organization_path

        click_on '招待'
        expect(current_path).to eq new_user_invitation_path

        expect do
          fill_in 'user[email]', with: invitee.email
          click_on '招待する'
        end.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(current_path).to eq organization_path
        expect(page).to have_content "招待メールが#{invitee.email}に送信されました。"

        logout(:user)

        # 招待された組織への参加
        invitation_mail = ActionMailer::Base.deliveries.last
        join_organization_url = URI.extract(invitation_mail.html_part.body.to_s)[0]

        visit join_organization_url
        expect(page).to have_content 'アカウント情報の設定'

        expect do
          fill_in 'user[name]', with: invitee.name
          fill_in 'user[password]', with: invitee.password
          fill_in 'user[password_confirmation]', with: invitee.password_confirmation
          click_on 'アカウント情報を設定する'
        end.to change { User.last.organization }.from(nil).to(user.organization)

        expect(current_path).to eq projects_path
        expect(page).to have_content 'アカウント情報が設定されました。お使いのアカウントでログインできます。'
      end
    end

    context '既存のユーザーを招待する場合' do
      let(:invitee) { create(:user) }

      it '招待と同時に組織に参加できること' do
        visit organization_path

        click_on '招待'
        expect(current_path).to eq new_user_invitation_path

        expect do
          fill_in 'user[email]', with: invitee.email
          click_on '招待する'
        end.to change { invitee.reload.organization }.from(nil).to(user.organization)

        expect(current_path).to eq organization_path
        expect(page).to have_content "#{invitee.email}が組織に参加しました。"
        expect(page).to have_content invitee.name
      end
    end
  end
end
