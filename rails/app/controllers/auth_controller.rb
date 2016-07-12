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
    params.require :code
    user = User.from_code params[:code]
    if user
      session[:user_id] = user&.id
      redirect_to dashboard_url
    else
      flash[:error] = "Oops! Something went wrong."
      redirect_to root_url
    end
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
