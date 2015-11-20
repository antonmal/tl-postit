class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :admin?, :moderator?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      please_login
    end
  end

  def admin?
    current_user.role == 'admin'
  end

  def moderator?
    current_user.role == 'moderator'
  end

  def please_login
    redirect_to root_path, alert: "You need to be logged in to do this."
  end
end
