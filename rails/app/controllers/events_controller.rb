class EventsController < ApplicationController
  include Hookable
  skip_before_action :ensure_signed_in

  def pull_request_event
    action = request.request_parameters["action"]
    if action == "opened"
      pr = params[:pull_request]
      repo = Repo.find_by(
        name: pr[:base][:repo][:name],
        owner: pr[:base][:repo][:owner][:login]
      )
      eva.remote.add_comment(
        repo.full_name,
        pr[:number],
        "Thanks for the PR 👌🏻"
      )
    end
  end

end
