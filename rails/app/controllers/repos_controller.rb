class ReposController < ApplicationController
  def update
    if signed_in?
      repo = Repo.find params[:id]
      if user == repo&.user
        logger.info "info"
        logger.info repo.update_attributes params.require(:repo).permit(:tracked)
      end
    end
  end
end
