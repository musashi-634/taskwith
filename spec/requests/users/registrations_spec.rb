require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/sign_up" do
    context 'ログインしていない場合' do
      before { get new_user_registration_path }

      it 'ユーザー登録ページに遷移できること' do
        expect(response).to have_http_status 200
        expect(response.body).to include 'アカウント登録'
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get new_user_registration_path
      end

      it 'プロジェクト一覧ページにリダイレクトされること' do
        expect(response).to redirect_to projects_path
      end
    end
  end
end
