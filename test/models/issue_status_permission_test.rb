require 'test_helper'

class IssueStatusPermissionTest < ActiveSupport::TestCase
  test "Issue access permissions to symbol" do
    isp = IssueStatusPermission.new
    assert_equal 8, isp.permission_flags_map.count,
      'IssueStatusPermission permission_flags has been changed'

    assert_equal [], isp.permissions

    isp.permission_flags = 1
    assert_equal %w(issue issue.view), isp.permissions

    isp.permission_flags = 4
    assert_equal %w(issue issue.edit), isp.permissions

    isp.permission_flags = 10
    assert_equal %w(issue issue.create inspection inspection.fill_up), isp.permissions

    isp.permission_flags = 255
    assert_equal %w(issue issue.view issue.create issue.edit inspection
      inspection.fill_up inspection.submit issue.delete inspection.view
      inspection.rollback), isp.permissions
  end
end
