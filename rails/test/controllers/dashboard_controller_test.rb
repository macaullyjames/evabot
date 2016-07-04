require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as users(:macaullyjames)
    get dashboard_index_url
    assert_response :success
  end

end
