class WelcomeController < ApplicationController
  skip_before_action :ensure_signed_in

  def index
  end

end
