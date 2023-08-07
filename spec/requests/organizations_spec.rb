require 'rails_helper'

RSpec.describe "Organizations", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /organization" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get organization_path }

      it '組織情報を取得できること' do
        expect(response.body).to include organization.id.to_s
        expect(response.body).to include organization.name
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      before { get organization_path }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end

  describe "GET /organization/new" do
    context 'ユーザーが組織に所属していない場合' do
      before { get new_organization_path }

      it '組織作成ページにアクセスできること' do
        expect(response).to have_http_status 200
        expect(response.body).to include '新規組織作成'
      end
    end

    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      before { get new_organization_path }

      it '組織詳細ページにリダイレクトされること' do
        expect(response).to redirect_to organization_path
        expect(flash[:alert]).to eq 'すでに組織に所属しています。'
      end
    end
  end
end
