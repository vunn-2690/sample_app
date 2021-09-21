class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expirate, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "users.password.mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "users.password.not_found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      flash.now[:danger] = t "users.password.empty"
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "users.password.success"
      redirect_to @user
    else
      flash.now[:danger] = t "users.password.fail"
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.password.not_found_user"
    render :new
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expirate
    return unless @user.password_reset_expired?

    flash[:danger] = t "users.password.has_expired"
    redirect_to new_password_reset_url
  end
end
