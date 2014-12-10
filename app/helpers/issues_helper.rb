module IssuesHelper
  def can_create_issue
    claims.issue_status_id_for('issue.create').count > 0
  end

  def creatable_status_list
    IssueStatus
      .where(:id => claims.issue_status_id_for('issue.create'))
      .pluck :name, :id
  end

  def issue_status_select_options
    [
      ['Status', [['Processing', 'processing'], ['Finished', 'finished']]],
      ['Specific Status', IssueStatus.permit_with(claims, 'issue.create').pluck(:name, :id)]
    ]
  end
end
