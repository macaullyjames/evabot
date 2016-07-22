require 'test_helper'

class ReposControllerTest < ActionDispatch::IntegrationTest

  setup do
    RemoteStub = Struct.new "RemoteStub" do
      def edit_hook(*args)
        true
      end
    end

    User.any_instance.stubs(:remote).returns(RemoteStub.new)
  end

  test "should be able to track/untrack repos" do
    user = users :macaullyjames
    repo = user.repos.first

    sign_in as: user

    repo.update tracked: false

    patch repo_url(repo), params: { repo: { tracked: true } }
    assert_response :success
    repo.reload
    assert repo.tracked?

    patch repo_url(repo), params: { repo: { tracked: false } }
    assert_response :success
    repo.reload
    assert_not repo.tracked?
  end

end
