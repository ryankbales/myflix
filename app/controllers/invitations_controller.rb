class InvitationsController < ApplicationController
  before_action :require_user
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(user_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.delay.send_invitation_email(@invitation)
      flash[:success] = "You have invited #{@invitation.recipient_name} to join MyFlix."
      redirect_to new_invitation_path
    else
      flash[:error] = "You forgot some required information."
      render :new
    end
  end

  def user_params
    params.require(:invitation).permit(:inviter_id, :recipient_name, :recipient_email, :message)
  end
end