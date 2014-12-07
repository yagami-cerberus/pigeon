require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "Group access permissions to symbol" do
    g = Group.new
    assert_equal 3, g.system_flags_map.count,
      'Group system_flags has been changed'

    assert_equal [], g.permissions

    g.system_flags = 2
    assert_equal %w(admin admin.manage_products), g.permissions

    g.system_flags = 5
    assert_equal(%w(admin admin.manage_users admin.manage_working_flow),
        g.permissions)
  end
end
