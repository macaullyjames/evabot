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

  test "from_code" do
    assert_nil(User.from_code "invalid_code")

    oauth_url = "https://github.com/login/oauth/access_token"
    user = User.all.sample
    stub_request(:post, oauth_url)
      .with(headers: { "Accept" => "application/json" })
      .to_return(body: {
        access_token: user.token,
        token_type: "bearer",
        scope: "admin:org,admin:repo_hook,repo"
        }.to_json
      )
    assert_equal user, User.from_code("any_code")

    assert_requested :post, oauth_url, times: 2
  end
end
