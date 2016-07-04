class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    if current_user
      redirect_to dashboard_index_path
    end
  end

  def create
    unless current_user
      token = params[:session][:token]
      user = User.find_by(token: token)
      unless user
        username = Octokit::Client.new(:access_token => token)&.user&.login
        user = User.create username: username, token: token
      end
      session[:user_id] = user.id
    end

    redirect_to dashboard_index_path
  rescue
      flash[:error] = 'Invalid token'
      redirect_to new_session_path
  end

  def destroy
  end

end
