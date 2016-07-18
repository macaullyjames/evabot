require 'rest-client'

class AuthController < ApplicationController

  def login
    if current_user
      redirect_to dashboard_url
    else
      client = Octokit::Client.new
      client_id = Rails.application.secrets.github_client_id
      auth_url = client.authorize_url client_id,
        redirect_uri: auth_callback_url,
        scope: "email repo admin:org admin:repo_hook"

      redirect_to auth_url
    end
  end

  def callback
    code = params[:code]
    client_id = Rails.application.secrets.github_client_id
    client_secret = Rails.application.secrets.github_client_secret
    response = Octokit.exchange_code_for_token code, client_id, client_secret
    token = response.access_token

    user = User.from_token token
    session[:user_id] = user&.id
    redirect_to dashboard_url
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
