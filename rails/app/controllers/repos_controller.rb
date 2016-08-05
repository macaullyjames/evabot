class ReposController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :check_owner

  def update
    repo.update repo_params

    is_collaborator = user.remote.collaborator?(repo.full_name, eva.login)
    local_dir = Rails.root.join "repos", repo.owner.login, repo.name
    if repo.tracked?
      FileUtils.mkdir_p local_dir
      url = "https://#{user.token}@github.com/#{repo.full_name}.git"
      callback_url = events_url host: Rails.configuration.host

      if user.remote.login
        %x( git clone #{url} #{local_dir} )
        user.remote.add_collaborator repo.full_name, eva.login
        hook = user.remote.create_hook(
          repo.full_name,
          "web",
          {
            url: callback_url,
            content_type: "json"
          },
          events: [ "*" ],
          active: true
        )
        repo.update hook_id: hook.id
      end
    else
      FileUtils.remove_dir local_dir, true
      user.remote.remove_collaborator repo.full_name, eva.login
      user.remote.remove_hook repo.full_name, repo.hook_id
      repo.update hook_id: nil
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
