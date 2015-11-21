class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :check_permissions, only: [:edit, :update]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: 'Your account was created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Your profile was updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(slug: params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def check_permissions
    if logged_in?
      unless @user == current_user || admin?
        redirect_to current_user, alert: "You can only edit your own profile."
      end
    else
      please_login
    end
  end
end
