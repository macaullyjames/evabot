class SessionsController < ApplicationController


  def create
    token = params[:session][:token]
    if token == "token"
      redirect_to dashboard_index_path
    else
      flash[:error] = 'Invalid token'
      redirect_to new_session_path
    end
  end

  def destroy
  end

end
