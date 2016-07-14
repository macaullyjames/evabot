class DashboardController < ApplicationController
  def index
    return redirect_to root_url unless current_user
    if current_user.remote
      user_repos = current_user.remote.repositories nil,
        affiliation: "owner",
        sort: "updated"
      member_repos = current_user.remote.repositories nil,
        affiliation: "organization_member",
        sort: "updated"
      member_repos.select! { |r| r.permissions.admin }
      @remote_repos = user_repos + member_repos
    end
  end
end
