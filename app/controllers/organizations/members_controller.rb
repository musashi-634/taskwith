class Organizations::MembersController < ApplicationController
  before_action :block_normal_user, except: %i(index new show edit)
  before_action :block_myself, except: %i(index new show edit)
  before_action :set_member, only: %i(show edit update)

  def show
  end

  def edit
  end

  def update
    if @member.update(user_params)
      flash[:notice] = '組織メンバーの権限を更新しました。'
      redirect_to organization_path
    else
      flash.now[:alert] = '組織メンバーの権限を更新できませんでした。'
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def block_normal_user
    redirect_to projects_path unless current_user.is_admin?
  end

  def block_myself
    redirect_to projects_path if params[:id].to_i == current_user.id
  end

  def set_member
    @member = current_user.organization.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:is_admin)
  end
end
