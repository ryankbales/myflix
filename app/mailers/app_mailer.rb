class AppMailer < ActionMailer::Base

  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "welcome to Myflix!"
  end

end