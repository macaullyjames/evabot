class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user, :signed_in?

  def user
    if session[:user_id]
      @user ||= User.find session[:user_id] 
    end
  end

  def signed_in?
    user.present?
  end

end
