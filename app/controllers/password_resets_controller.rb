class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_token(params[:token])
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:success] = "Your password has been reset.  Sign in to continue."
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def show
    user = User.find_by_token(params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end
end