require 'rails_helper'

RSpec.describe "Users::Sessions::Guests", type: :request do
  # create
  describe "POST /users/guests/sign_in" do
    context 'ログインしていない場合' do
      context 'ゲストユーザーがDBに存在する場合' do
        let!(:guest_user) { create(:guest_user) }

        before { post users_guest_session_path }

        it 'ログインできること' do
          expect(response).to redirect_to projects_path
          expect(flash[:notice]).to include 'ゲストユーザーとしてログインしました。'
        end
      end

      context 'ゲストユーザーがDBに存在しない場合' do
        before { post users_guest_session_path }

        it 'ログインできること' do
          expect(response).to redirect_to projects_path
          expect(flash[:notice]).to include 'ゲストユーザーとしてログインしました。'
        end
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user) }

      before do
        sign_in user
        post users_guest_session_path
      end

      it '新たにログインされないこと' do
        expect(response).to redirect_to projects_path
        expect(flash[:alert]).to include 'すでにログインしています。'
      end
    end
  end
end
