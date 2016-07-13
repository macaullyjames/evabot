class DashboardController < ApplicationController
  def index
    unless current_user
      redirect_to root_url
    end
  end
end
