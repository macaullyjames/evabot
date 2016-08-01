require 'rest-client'

class AuthController < ApplicationController
  skip_before_action :ensure_signed_in

  def login
    if signed_in?
      redirect_to dashboard_url
    elsif params[:token].present?
      sign_in token: params[:token]
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
    token = Octokit.exchange_code_for_token(
      params[:code],
      client_id,
      client_secret
    ).access_token

    login = Octokit::Client.new(access_token: token).user.login
    user = User.find_by login: login
    if user.blank?
      user = User.create login: login, token: token
      user.sync by: :fetching
    else
      user.update token: token
    end

    sign_in as: user
    redirect_to dashboard_url
  end

  def logout
    sign_out
    redirect_to root_path
  end
end
