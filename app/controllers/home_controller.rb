class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :block_user_belongs_to_no_organization

  def index
  end
end
