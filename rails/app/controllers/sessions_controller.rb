class SessionsController < ApplicationController

  def create
    token = params[:session][:token]
    username   = User.find_by(token: token)&.username 
    username ||= Octokit::Client.new(:access_token => token)&.user&.login
    flash[:error] = username
    redirect_to dashboard_index_path
  rescue
      flash[:error] = 'Invalid token'
      redirect_to new_session_path
  end

  def destroy
  end

end
