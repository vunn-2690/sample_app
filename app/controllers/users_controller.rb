class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :load_user, except: %i(index new create following followers)
  before_action :check_admin, only: :destroy

  def index
    @users = User.paginate(
      page: params[:page],
      per_page: Settings.per_page_10
    )
    @microposts = @user.microposts.paginate(
      page: params[:page],
      per_page: Settings.per_page_10
    )
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.mail.please_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "users.edit.success"
      redirect_to @user
    else
      flash[:danger] = t "users.edit.fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.success"
    else
      flash[:danger] = t "users.destroy.fail"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("shared.not_found_user")
    redirect_to signup_path
  end

  def check_admin
    return if current_user.admin?

    flash[:danger] = t "users.destroy.admin_fail"
    redirect_to users_url
  end
end
