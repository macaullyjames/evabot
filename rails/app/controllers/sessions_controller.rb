require 'authenticator'

class SessionsController < ApplicationController

  def create
    token = params[:session][:token]
    username = Authenticator.get_username token
    if username
      flash[:error] = username
      redirect_to dashboard_index_path
    else 
      flash[:error] = 'Invalid token'
      redirect_to new_session_path
    end
  end

  def destroy
  end

end
