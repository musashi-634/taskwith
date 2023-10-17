class Users::Sessions::GuestsController < Devise::SessionsController
  def create
    user = User.guest
    sign_in user
    flash[:notice] = 'ゲストユーザーとしてログインしました。'
    redirect_to after_sign_in_path_for(user)
  end
end
