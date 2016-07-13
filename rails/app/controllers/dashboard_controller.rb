class DashboardController < ApplicationController
  def index
    return redirect_to root_url unless current_user
    if current_user.remote
      remote = current_user.remote
      @owner_repos = remote.repositories(nil, affiliation: "owner")
      @collaborator_repos = remote.repositories(nil, affiliation: "collaborator")
      @org_repos = {}
      remote.repositories(nil, affiliation: "organization_member")
        .each do |repo|
          owner_name  = repo.owner.login
          @org_repos[owner_name] ||= []
          @org_repos[owner_name] << repo
        end
    end
  end
end
