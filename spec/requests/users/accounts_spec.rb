require 'rails_helper'

RSpec.describe "Users::Account", type: :request do
  # show
  describe "GET /users/account" do
    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get users_account_path
      end

      it 'アカウント情報を取得できること' do
        expect(response.body).to include 'アカウント情報'
        expect(response.body).to include user.name
        expect(response.body).to include user.email
      end
    end

    context 'ログインしていない場合' do
      before { get users_account_path }

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to user_session_path
      end
    end
  end
end
