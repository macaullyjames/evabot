ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Sign in as the given user. Passing nil will result in a failed login
  # attempt.
  def sign_in_as(user)
    post sessions_path, params: { session: { token: user&.token } }
  end
end
