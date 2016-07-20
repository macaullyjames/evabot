require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  setup do
    sign_in
  end

  test "normal behaviour" do
    # The "X-Github-Event" header is required
    post events_url, headers: { "X-GitHub-Event": "repos" }
    assert_response :success
    post events_url
    assert_response :bad_request

    # Unknown/invalid events are fine though
    post events_url, headers: { "X-GitHub-Event": "unknown_event" }
    assert_response :success
  end

end
