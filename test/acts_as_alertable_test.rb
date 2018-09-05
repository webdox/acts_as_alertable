require 'test_helper'

class ActsAsAlertableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActsAsAlertable
  end
end
