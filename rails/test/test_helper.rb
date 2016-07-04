ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Sign in as the given user. Passing nil will result in a failed login
  # attempt.
  def sign_in_as(user)
    post session_path, params: { session: { token: user&.token } }
  end

  # Sign in with some user
  def sign_in
    sign_in_as User.all.sample
  end

  def sign_out
    delete session_path
  end

  def signed_in?
    session.key?(:user_id)
  end
end
