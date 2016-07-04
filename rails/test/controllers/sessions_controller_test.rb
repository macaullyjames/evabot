require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "basic functionality" do
    sign_in
    assert signed_in?
    sign_out
    assert_not signed_in?
  end

  test "redirect to the dashboard after login" do
    sign_in
    assert_redirected_to dashboard_index_path
  end

  test "redirect to the login form after invalid login attempt" do
    sign_in_as nil
    assert_redirected_to new_session_path
  end

  test "redirect to the root path after logout" do
    sign_in
    sign_out
    assert_redirected_to root_path
  end

  test "flash an error after invalid login attempt" do
    get new_session_path
    assert_select '.flash.error', false

    sign_in_as nil
    follow_redirect!
    assert_select '.flash.error'

    get new_session_path
    assert_select '.flash.error', false
  end
end
