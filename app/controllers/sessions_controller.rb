class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user.try(:authenticate, params[:session][:password])
      if user.activated
        login user
      else
        flash[:warning] = t "users.mail.unactivated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "shared.invalid_email_password_combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
