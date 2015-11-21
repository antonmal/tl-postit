class SessionsController < ApplicationController
  def new

  end

  # Two-factor auth
  #
  # 1. Add 'phone' and 'pin' attributes to users table.
  # 2. Ask for login and password
  #   A. if successful and user has phone filled in
  #     1. generate a pin
  #     2. save it to the database
  #     3. send the pin to use by sms via Twilio
  #     4. redirect to the pin form
  #       i. if login is successful
  #         - do the normal login actions
  #       ii. if not
  #         - redirect to the login form with an error
  #   B. if successful, but user has no phone filled in
  #     1. login the user normally
  #   C. if unsuccessful
  #     1. render the login form with an error

  def create
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      if @user.two_factor_login?
        @user.generate_pin!
        @user.send_pin_via_twilio
        session[:two_factor_id] = @user.id
        redirect_to pin_path
      else
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Welcome, #{@user.username}! You successfully logged in."
      end
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

  def pin
    redirect_to root_path, alert: 'You cannot do this.' unless session[:two_factor_id] && !session[:two_factor_id].nil?

    if request.post?
      @user = User.find(session[:two_factor_id])
      if params[:pin] == @user.pin
        session[:user_id] = @user.id
        session[:two_factor_id] = nil
        @user.update(pin: nil)
        redirect_to root_path, notice: "Welcome, #{@user.username}! You successfully logged in."
      else
        redirect_to pin_path, alert: 'Something was wrong with the PIN.'
      end
    end
  end
end
