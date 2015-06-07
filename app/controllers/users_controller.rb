class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      process_invitation
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]

      begin
        StripeWrapper::Charge.create(
          :amount => 999, # amount in cents, again
          :source => token,
          :description => "Sign up charge for #{@user.email}"
        )
      rescue Stripe::CardError => e
        flash[:error] = "There was a problem processing you card."
      end
      AppMailer.send_welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  private

  def process_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by_token(params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end