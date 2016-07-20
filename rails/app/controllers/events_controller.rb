class EventsController < ApplicationController
  include Hookable
  skip_before_action :ensure_signed_in

end
