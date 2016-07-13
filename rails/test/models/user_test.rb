require 'test_helper'
require 'ostruct'

class UserTest < ActiveSupport::TestCase

  test "from_token" do
    assert_no_difference 'User.count' do
      assert_nil(User.from_token "invalid_token")
      assert_not_nil(User.from_token User.all.sample.token)
    end

    assert_difference 'User.count' do
      # Stub octokit to return a valid user no matter what the token is
      Octokit::Client.any_instance
        .stubs(:user)
        .returns(OpenStruct.new login: "mocked_user")

      assert_not_nil(User.from_token "test_token")
    end
  end

end
