class PasswordResetsController < ApplicationController
  def show
     user = User.find_by_token(params[:id])
     redirect_to expired_token_path unless user
  end
end