class DashboardController < ApplicationController
  def index
    redirect_to root_url unless signed_in?
  end
end
