class ApplicationController < ActionController::Base
  before_action :require_login

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_session_path
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find session[:user_id] 
    end
  end
end
