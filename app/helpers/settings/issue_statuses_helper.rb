module Settings::IssueStatusesHelper
  def checked(status)
    if status
      '<span class="fa fa-lg fa-check-circle text-success"></span>'.html_safe
    else
      ''
    end
  end
  
  def issue_status(id)
    @issue_statuses ||= Hash[IssueStatus.all.map {|i| [i.id, i]}]
    i = @issue_statuses[id]
    link_to i.name, [:settings, i] if i
  end
end
