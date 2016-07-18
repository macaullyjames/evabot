class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user, :sign_in, :sign_out, :signed_in?

  def user
    if session[:user_id]
      @user ||= User.find session[:user_id] 
    end
  end

  def sign_in(as:)
    session[:user_id] = as&.id
  end

  def sign_out
    reset_session
  end

  def signed_in?
    user.present?
  end

end
