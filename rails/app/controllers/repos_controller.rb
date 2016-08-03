class ReposController < ApplicationController
  before_action :check_owner

  def update
    repo.update repo_params
    user.remote.edit_hook(
      repo.full_name,
      repo.hook_id,
      "web",
      {
        url: events_url,
        content_type: "json"
      },
      events: [ "*" ],
      active: repo.tracked?
    )

    is_collaborator = user.remote.collaborator?(repo.full_name, eva.login)
    if repo.tracked? and not is_collaborator
      user.remote.add_collaborator(repo.full_name, eva.login)
    elsif not repo.tracked? and is_collaborator
      user.remote.remove_collaborator(repo.full_name, eva.login)
    end

  end

  private

  def repo
    @repo ||= Repo.find params[:id]
  end

  def repo_params
    params.require(:repo).permit(:tracked)
  end

  def check_owner
    halt :bad_request unless user.repos(permission: :admin).include? repo
  end
end
