class SessionsController < ApplicationController

  def new
  end

  def create
    token = params[:session][:token]
    user = User.find_by(token: token)
    unless user
      username = Octokit::Client.new(:access_token => token)&.user&.login
      user = User.create username: username, token: token
    end
    session[:user_id] = user.id

    redirect_to dashboard_index_path
  rescue
    flash[:error] = 'Invalid token'
    redirect_to new_session_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

end
