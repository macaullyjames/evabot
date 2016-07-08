ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def sign_in(as: User.all.sample)
    AuthController.any_instance.stubs(:token_from).returns(as.token)
    get auth_callback_url, params: { code: "test" }
  end

  def sign_out
    get logout_url
  end

end
