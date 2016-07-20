require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  test "should post new" do
    sign_in
    post events_url
    assert_response :success
  end

end
