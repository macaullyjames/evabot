require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest

  setup do
    @internal_url = /^#{root_url}/
    @external_url = /^(?!#{root_url}).*/
  end

  test "should update the session variable" do
    user = User.all.sample
    sign_in as: user
    assert_equal session[:user_id], user.id
    sign_out
    assert_nil session[:user_id]
  end

  test "should redirect to external service if not logged in" do
    get login_url
    assert_redirected_to @external_url
  end

  test "should redirect to an internal page if already logged in" do
    sign_in
    get login_url
    assert_redirected_to @internal_url

    # Make sure we're not in a redirect loop
    follow_redirect!
    assert_response :success
  end

end
