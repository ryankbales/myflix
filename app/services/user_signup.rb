class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?

      charge = StripeWrapper::Charge.create({
        amount: 999,
        currency: "usd",
        source: stripe_token,
        description: "Sign up charge for #{@user.email}"
      })

      if charge.successful?
        @user.save
        process_invitation(invitation_token)
        AppMailer.send_welcome_email(@user).deliver
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user information. Please check the errors below."
    end
    self
  end

  def successful?
    @status == :success
  end

  private

  def process_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(["token = :t", { t: invitation_token }]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end