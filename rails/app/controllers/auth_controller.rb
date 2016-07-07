require 'rest-client'

class AuthController < ApplicationController
  include AuthHelper

  def login
    if current_user
      redirect_to dashboard_url
    else
      redirect_to authorization_url
    end
  end

  def callback
    params.require :code

    # Exchange the auth code for an access token
    token = token_from params[:code]
    # Find or create a user from the access token
    user = user_from token
    # Log the user in
    session[:user_id] = user.id
    redirect_to dashboard_url
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
