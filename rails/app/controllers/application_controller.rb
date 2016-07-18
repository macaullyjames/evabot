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

  def client_id
    Rails.application.secrets.github_client_id
  end

  def client_secret
    Rails.application.secrets.github_client_secret
  end

  def sign_in(as: nil, **opts)
    if as.present?
      session[:user_id] = as.id
    elsif opts.present?
      sign_in as: User.find_by(opts)
    end
  end

  def sign_out
    reset_session
  end

  def signed_in?
    user.present?
  end

end
