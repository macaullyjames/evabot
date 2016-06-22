require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @login_params = Hash.new
    @login_params[:invalid] = { session: { token: "" } }
    User.find_each do |user|
      @login_params[:"#{user.username}"] = { session: { token: user.token } }
    end
  end

  test "should redirect after login attempt" do
    # Invalid login attempts should redirect back to the login form 
    post sessions_path, params: @login_params[:invalid]
    assert_redirected_to new_session_path

    # Valid login attempts should redirect to the dashboard
    post sessions_path, params: @login_params[:macaullyjames]
    assert_redirected_to dashboard_index_path
  end

  test "should show error message after invalid login attempt" do
    # Don't show an error message if we haven't tried to log in
    get new_session_path
    assert_select '.flash.error', false

    # Show an error message after an invalid login
    post sessions_path, params: @login_params[:invalid]
    follow_redirect!
    assert_select '.flash.error'

    # If we refresh the page after an invalid login the error message
    # shouldn't be displayed
    get new_session_path
    assert_select '.flash.error', false
  end
end
