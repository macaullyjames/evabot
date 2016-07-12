ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  WebMock.allow_net_connect!

  def sign_in(as: User.all.sample)
    User.stubs(:from_code).returns as
    get auth_callback_url, params: { code: "test" }
  end

  def sign_out
    get logout_url
  end
end
