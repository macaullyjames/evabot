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
  end

  private

  def repo
    @repo ||= Repo.find params[:id]
  end

  def repo_params
    params.require(:repo).permit(:tracked)
  end

  def check_owner
    halt :bad_request unless user == repo&.user
  end
end
