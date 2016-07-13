require 'rest-client'

class AuthController < ApplicationController

  def login
    if current_user
      redirect_to dashboard_url
    else
      github_auth_url = "https://github.com/login/oauth/authorize"
      github_auth_params = {
        client_id: Rails.application.secrets.github_client_id,
        redirect_uri: auth_callback_url,
        scope: "email repo admin:org admin:repo_hook"
      }
      redirect_to "#{github_auth_url}?#{github_auth_params.to_query}"
    end
  end

  def callback
    code = params[:code]
    client_id = Rails.application.secrets.github_client_id
    client_secret = Rails.application.secrets.github_client_secret
    response = Octokit.exchange_code_for_token code, client_id, client_secret
    token = JSON.parse(response.body)["access_token"]

    user = User.from_token token
    session[:user_id] = user&.id
    redirect_to dashboard_url
  rescue
    flash[:error] = "Oops! Something went wrong."
    redirect_to root_url
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
