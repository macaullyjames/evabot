require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest

  test "should update the session variable" do
    user = User.all.sample
    sign_in as: user
    assert_equal session[:user_id], user.id
    sign_out
    assert_nil session[:user_id]
  end

  test "/login" do
    external_url = /^(?!#{root_url}).*/

    get login_url
    assert_redirected_to external_url

    sign_in
    get login_url
    assert_redirected_to dashboard_url

    # Make sure we're not in a redirect loop
    follow_redirect!
    assert_response :success
  end
end
