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
    5 => :delete_issue
  }

end
