class ReposController < ApplicationController

  def update
    repo = Repo.find params[:id]
    if user == repo&.user
      repo.update repo_params
    end
  end

  private

  def repo_params
    params.require(:repo).permit(:tracked)
  end

end
