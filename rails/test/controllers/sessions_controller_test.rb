require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect to the login page after an invalid login attempt" do
    sign_in_as nil
    assert_redirected_to new_session_path
  end

  test "should redirect to the dashboard after a valid login attempt" do
    sign_in_as users(:macaullyjames)
    assert_redirected_to dashboard_index_path
  end

  test "should remember the user after logging in once" do
    sign_in_as users(:macaullyjames)
    get new_session_path
    assert_redirected_to dashboard_index_path
    sign_in_as nil
    assert_redirected_to dashboard_index_path
  end

  test "should show error message after invalid login attempt" do
    # Don't show an error message if we haven't tried to log in
    get new_session_path
    assert_select '.flash.error', false

    # Show an error message after an invalid login
    sign_in_as nil
    follow_redirect!
    assert_select '.flash.error'

    # If we refresh the page after an invalid login the error message
    # shouldn't be displayed
    get new_session_path
    assert_select '.flash.error', false
  end

  test "logout should work as expected" do
    sign_out
    assert_not signed_in?

    sign_in_as users(:macaullyjames)
    sign_out
    assert_not signed_in?
  end
end
