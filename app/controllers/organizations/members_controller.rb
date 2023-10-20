class Organizations::MembersController < ApplicationController
  before_action :set_member, only: %i(show edit update)

  def show
  end

  def edit
  end

  def update
  end

  private

  def set_member
    @member = current_user.organization.users.find(params[:id])
  end
end
