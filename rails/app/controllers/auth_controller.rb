require 'rest-client'

class AuthController < ApplicationController
  def login
    if params[:code]
      url = "https://github.com/login/oauth/access_token"
      post_params = { 
        client_id: Rails.application.secrets.github_client_id,
        client_secret: Rails.application.secrets.github_client_secret,
        code: params[:code]
      }
      r = RestClient.post url, post_params, :accept => :json
      token = JSON.parse(r.body)["access_token"]
      user = User.find_by token: token
      unless user
        username = Octokit::Client.new(:access_token => token)&.user&.login
        user = User.create username: username, token: token
      end
      session[:user_id] = user.id
      flash[:error] = user.username
      redirect_to dashboard_index_path
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
