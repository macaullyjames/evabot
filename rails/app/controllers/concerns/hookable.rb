module Hookable
  extend ActiveSupport::Concern

  def create
    if event_name.blank?
      head :bad_request
    else
      if self.respond_to? event_method
        send event_method, JSON.parse(request.body)
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
