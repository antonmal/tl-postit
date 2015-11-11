class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome, #{@user.username}! You successfully logged in."
    else
      flash[:alert] = 'Wrong username and/or password'
      render 'new'
    end
  end

  def destroy
    if session[:user_id]
      session[:user_id] = nil
      redirect_to root_path, notice: 'You logged out successfully. See you soon!'
    else
      redirect_to root_path, alert: 'Failed to log out. Not sure what to do.'
    end
  end
end
