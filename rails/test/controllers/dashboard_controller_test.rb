require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_url
    assert_redirected_to root_url

    sign_in
    get dashboard_url
    assert_response :success
  end

end
