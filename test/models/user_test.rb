require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Exist Password Hash" do
    u = User.find_by_login('sha256_test_user')
    assert u.challenge_password("pigeon"),
      "Unittest account password challenge failed"

    assert_not u.challenge_password("pigeon2"),
        "Unittest account password challenge failed"

    assert_nil u.password
  end

  test "Password Hash" do
    u = User.find_by_login('regular_user')
    assert u.challenge_password("moo~"),
      "Unittest account password challenge failed"

    assert_not u.challenge_password("moo~2"),
        "Unittest account password challenge failed"
  end

  test "Raw merged groups permissions" do
    # Test belongs to single group
    u = User.find_by_login('admin')
    assert_equal 4294967295, u.groups.merged_group.system_flags

    # Test belongs to many groups
    u = User.find_by_login('leader')
    assert_equal 3, u.groups.merged_group.system_flags

    # Test no group
    u = User.find_by_login('guest')
    assert_equal 0, u.groups.merged_group.system_flags
  end

  test "Raw merged issue access permissions" do
    get_permission_flags = lambda { |user, issue_status_id|
      user
        .issue_status_permissions
        .merged_issue_status_permissions
        .find_by_issue_status_id(issue_status_id)
        .permission_flags
    }

    get_issue_status_ids = lambda { |user, issue_status_id|
      user
        .issue_status_permissions
        .merged_issue_status_permissions
        .find_by_issue_status_id(issue_status_id)
        .issue_status_ids
    }

    # Test belongs to single group
    u = User.find_by_login('typist')
    assert_equal 39, get_permission_flags.call(u, 1)
    assert_equal 1, get_permission_flags.call(u, 2)
    assert_equal [2], get_issue_status_ids.call(u, 1)
    assert_equal [], get_issue_status_ids.call(u, 2)

    # Test belongs to multi groups
    u = User.find_by_login('leader')
    assert_equal 39, get_permission_flags.call(u, 2)
    assert_equal 231, get_permission_flags.call(u, 3)
    assert_equal [1, 3, 6], get_issue_status_ids.call(u, 2)
    assert_equal [1, 2, 4], get_issue_status_ids.call(u, 3)

    # Test no group
    u = User.find_by_login('guest')
    assert_equal({}, u.issue_status_permissions.permissions)
  end
end
