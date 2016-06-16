class HooksController < ActionController::Base
  include GithubWebhook::Processor

  # Handle push event
  def github_push(payload)
    # TODO: handle push webhook
  end

  # Handle create event
  def github_create(payload)
    # TODO: handle create webhook
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end
end
