require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /home" do
    before { get home_path }

    it 'ホームページに遷移できること' do
      expect(response).to have_http_status 200
    end
  end
end
