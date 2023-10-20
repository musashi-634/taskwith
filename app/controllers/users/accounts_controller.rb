class Users::AccountsController < ApplicationController
  skip_before_action :block_user_belongs_to_no_organization

  def show
  end
end
