class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("users.mail.activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("users.mail.reset_pasword")
  end
end
