require 'rest-client'

class AuthController < ApplicationController
  def login
    params.require :code

    # Exchange the auth code for an access token
    token = helpers.token_from params[:code]

    # Find or create a user from the access token
    current_user = helpers.user_from token

    redirect_to dashboard_url
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
