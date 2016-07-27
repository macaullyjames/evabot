require 'test_helper'

class RepoTest < ActiveSupport::TestCase

  test "full_name" do
    repo = Repo.new owner_name: "macaullyjames", name: "evabot"
    assert_equal repo.full_name, "macaullyjames/evabot"
  end

end
