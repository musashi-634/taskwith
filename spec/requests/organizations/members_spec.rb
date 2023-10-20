require 'rails_helper'

RSpec.describe "Organizations::Members", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  # show
  describe "GET /organizations/members/:id" do
    context 'ユーザーが組織に所属している場合' do
      let!(:organization) { create(:organization, users: [user]) }

      context '所属組織のメンバーを指定した場合' do
        let(:other_user) { create(:user, organization: organization) }

        before { get organizations_member_path(other_user) }

        it '組織メンバーの情報を取得できること' do
          expect(response).to have_http_status 200
          expect(response.body).to include other_user.name
          expect(response.body).to include other_user.email
          expect(response.body).to include other_user.display_admin_privilege
        end
      end

      context '所属組織のメンバー以外を指定した場合' do
        let(:other_user) { create(:user, :with_organization) }

        it 'エラーが発生すること' do
          expect do
            get organizations_member_path(other_user)
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context 'ユーザーが組織に所属していない場合' do
      let(:other_user) { create(:user, :with_organization) }

      before { get organizations_member_path(other_user) }

      it '組織作成ページにリダイレクトされること' do
        expect(response).to redirect_to new_organization_path
      end
    end
  end
end
