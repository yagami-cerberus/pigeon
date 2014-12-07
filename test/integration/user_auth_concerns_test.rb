require 'test_helper'
require 'user_auth'

class UserAuthConcernsTest < ActionDispatch::IntegrationTest
  def create_claims user
    temp = RegularClaims.to_claim_session(user).to_json
    RegularClaims.new JSON.parse(temp).symbolize_keys
  end

  test "permit system actions" do
    c = create_claims User.find_by_login('admin')
    ['admin', 'admin.manage_users'].each do |action|
        assert c.permit?(:system, action), "User 'admin' should permit action: #{action}"
    end

    c = create_claims User.find_by_login('typist')
    ['admin', 'admin.manage_users'].each do |action|
        assert_not c.permit?(:system, action), "User 'typist' should not permit action: #{action}"
    end
  end

  test "permit issue actions" do
    padding_issue = Issue.find(ActiveRecord::FixtureSet.identify(:padding_issue))
    confirming_issue = Issue.find(ActiveRecord::FixtureSet.identify(:confirming_issue))

    c = create_claims User.find_by_login('guest')
    assert_not c.permit?(padding_issue, 'issue.view')

    c = create_claims User.find_by_login('typist')
    assert c.permit?(padding_issue, 'issue.view')
    assert c.permit?(padding_issue, 'issue.edit')
    assert c.permit?(confirming_issue, 'issue.view')
    assert_not c.permit?(confirming_issue, 'issue.edit')

    assert_equal [2], c.can_update_issue_status_to(padding_issue)
    assert_equal [], c.can_update_issue_status_to(confirming_issue)


    c = create_claims User.find_by_login('manager')
    assert c.permit?(padding_issue, 'issue.view')
    assert c.permit?(padding_issue, 'issue.edit')
    assert c.permit?(confirming_issue, 'issue.view')
    assert c.permit?(confirming_issue, 'issue.edit')
    assert_not c.permit?(confirming_issue, 'inspection.submit')

    assert_equal [2, 3, 6], c.can_update_issue_status_to(padding_issue)
    assert_equal [1, 3], c.can_update_issue_status_to(confirming_issue)
  end
  
  test "get valid issue status" do
    c = create_claims User.find_by_login('guest')
    assert_equal [], c.issue_status_id_for("issue.view").sort

    c = create_claims User.find_by_login('typist')
    assert_equal [1, 2, 3, 4, 5, 6], c.issue_status_id_for("issue.view").sort
    assert_equal [1], c.issue_status_id_for("issue.edit").sort

    c = create_claims User.find_by_login('manager')
    assert_equal [1, 2, 3, 4, 5, 6], c.issue_status_id_for("issue.view").sort
    assert_equal [1, 2, 3, 4], c.issue_status_id_for("issue.edit").sort
  end
end
