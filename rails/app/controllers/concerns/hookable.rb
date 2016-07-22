module Hookable
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token
  end

  def create
    if event_name.blank?
      head :bad_request
    else
      if self.respond_to? event_method
        send event_method, JSON.parse(request.body)
      else
        logger.info "Unhandled hook: #{event_name}"
      end
      head :ok
    end
  end

  def event_name
    request.headers['X-GitHub-Event']
  end

  def event_method
    if event_name.present?
      "#{event_name}_event".to_sym
    end
  end

end
