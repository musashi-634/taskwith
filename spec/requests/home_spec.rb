require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    before { get home_index_path }

    it 'ホームページに遷移できること' do
      expect(response.body).to include 'Home#index'
    end
  end
end
