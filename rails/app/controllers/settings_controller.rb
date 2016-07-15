class SettingsController < ApplicationController
  def index
    return redirect_to root_url unless current_user
    if current_user.remote
      @remote_repos = current_user.remote.repositories.select do |r|
        r.permissions.admin
      end
    end
  end
end
