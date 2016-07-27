require 'test_helper'

class RepoTest < ActiveSupport::TestCase

  test "full_name" do
    assert_equal repos(:evabot).full_name, "macaullyjames/evabot"
  end

end
