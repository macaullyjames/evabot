require 'test_helper'
require 'minitest/mock'
require 'authenticator'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def login_params 
    {
      valid: { session: { token: "token" } },
      invalid: { session: { token: "" } }
    }
  end

  test "should redirect after login attempt" do
    # Invalid login attempts should redirect back to the login form 
    Authenticator.stub(:get_username, nil) do
      post sessions_path, params: login_params[:invalid]
      assert_redirected_to new_session_path
    end

    # Valid login attempts should redirect to the dashboard
    Authenticator.stub(:get_username, "success") do
      post sessions_path, params: login_params[:valid]
      assert_redirected_to dashboard_index_path
    end
  end

  test "should show error message after invalid login attempt" do
    # Don't show an error message if we haven't tried to log in
    get new_session_path
    assert_select '.flash.error', false

    # Show an error message after an invalid login
    post sessions_path, params: login_params[:invalid]
    follow_redirect!
    assert_select '.flash.error'

    # If we refresh the page after an invalid login the error message
    # shouldn't be displayed
    get new_session_path
    assert_select '.flash.error', false
  end
end
