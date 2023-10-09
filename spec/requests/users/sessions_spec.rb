require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe "GET /users/sign_in" do
    context 'ログインしていない場合' do
      before { get new_user_session_path }

      it 'ログインページに遷移できること' do
        expect(response).to have_http_status 200
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        get new_user_session_path
      end

      it 'プロジェクト一覧ページにリダイレクトされること' do
        expect(response).to redirect_to projects_path
      end
    end
  end
end
