require 'rest-client'

class AuthController < ApplicationController

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
    code = params[:code]

    secrets = Rails.application.secrets
    client_id = secrets.github_client_id
    client_secret = secrets.github_client_secret
    response = Octokit.exchange_code_for_token code, client_id, client_secret
    token = response.access_token

    remote = Octokit::Client.new access_token: token
    user = User.where(username: remote.user.login).first_or_create
    user.token = token

    remote.repositories.each do |repo|
      if repo.permissions.admin
        r = Repo.where(owner: repo.owner.login, name: repo.name).first_or_create
        r.user_id = user.id
        r.save
      end
    end

    sign_in user: user
    redirect_to dashboard_url
  end

  def logout
    sign_out
    redirect_to root_path
  end
end
