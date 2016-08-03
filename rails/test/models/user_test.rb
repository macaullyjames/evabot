require 'test_helper'
require 'ostruct'

class UserTest < ActiveSupport::TestCase
  test "should be able to filter repos by permission" do
    user = users :macaullyjames
    default = user.repos
    owner = user.repos(permission: :owner)
    admin = user.repos(permission: :admin)
    push = user.repos(permission: :push)
    pull = user.repos(permission: :pull)

    assert_not_empty default
    assert_equal default, owner

    assert_empty owner - admin
    assert_empty admin - push
    assert_empty push - pull
    assert_operator owner.count, :<, admin.count
    assert_operator admin.count, :<, push.count
    assert_operator push.count, :<, pull.count
  end
end
