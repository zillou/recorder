class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def sign_in(user)
    session[:remember_token] = user.remember_token
  end

  def current_user
    @current_user ||= User.find_by_remember_token(session[:remember_token]) if session[:remember_token]
  end
  helper_method :current_user

  def authorize
    redirect_to signin_path, alert: "You are not authorized!" if current_user.nil?
  end
end
