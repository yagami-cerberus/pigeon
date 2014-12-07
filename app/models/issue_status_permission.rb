class IssueStatusPermission < ActiveRecord::Base
  belongs_to :issue_status
  belongs_to :group
  
  include BitFlags
  
  bit_flags :permission_flags, {
    0 => :view_issue,
    1 => :create_issue,
    2 => :edit_issue,
    3 => :fill_up_values,
    4 => :submit_values,
    5 => :delete_issue,
    6 => :view_values,
    7 => :rollback_values
  }

  PERMISSIONS = {
    :view_issue => 'issue.view',
    :create_issue => 'issue.create',
    :edit_issue => 'issue.edit',
    :fill_up_values => 'inspection.fill_up',
    :submit_values => 'inspection.submit',
    :delete_issue => 'issue.delete',
    :view_values => 'inspection.view',
    :rollback_values => 'inspection.rollback'
  }

  def permissions
    roles = Set.new
    PERMISSIONS.each do |symbol, role|
      if self.send(symbol)
        splited_role = role.split('.')
        splited_role.length.times do |i|
          roles.add splited_role[0..i].join('.')
        end
      end
    end
    roles.to_a
  end
end
