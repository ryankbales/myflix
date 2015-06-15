class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        redirect_to home_path, notice: "Welcome #{user.full_name}!"
      else
        flash[:error] = "Your account has been deactivated.  Please give us a shout to fix it."
        redirect_to sign_in_path
      end
    else
      flash[:errors] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You are signed out."
  end
end