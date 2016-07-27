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

    # Find or create the user
    login = Octokit::Client.new(access_token: token).user.login
    user = User.where(login: login).first_or_create
    user.update token: token

    # Create an Owner from the user
    Owner.where(ownerable: user).first_or_create

    user.sync by: :fetching

    # Create the repo hooks
    user.repos.each do |repo|
      if repo.owner == user.login and repo.hook_id.blank?
        hook = user.remote.create_hook(
          repo.full_name,
          "web",
          {
            url: events_url,
            content_type: "json"
          },
          events: [ "*" ],
          active: repo.tracked?
        )
        repo.update hook_id: hook.id
      end
    end

    # Create the team's repos
    user.teams.each do |team|
      if team.repos.blank?
        user.remote.team_repos(team.remote_id).each do |r|
          owner = Owner.find_by ownerable: team.organization
          repo = Repo.where(owner: owner, name: r.name).first_or_create
          repo.update tracked: false
          permission =
            if r.permissions.admin then :admin
            elsif r.permissions.push then :push
            elsif r.permissions.pull then :pull
            else :none
            end
          TeamPermission.create(
            team: team,
            repo: repo,
            permission: permission
          )
          if repo.hook_id.blank? and permission == :admin
            hook = user.remote.create_hook(
              repo.full_name,
              "web",
              {
                url: events_url,
                content_type: "json"
              },
              events: [ "*" ],
              active: repo.tracked?
            )
            repo.update hook_id: hook.id
          end
        end
      end
    end

    sign_in as: user
    redirect_to dashboard_url
  end

  def logout
    sign_out
    redirect_to root_path
  end
end
