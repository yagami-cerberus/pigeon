class Settings::IssueStatusesController < ApplicationController
  def index
    @is = IssueStatus.all
  end
  
  def show
    @status = IssueStatus.find(params[:id])
  end
  
  def new
    @status = IssueStatus.new
    @status.prepare_group_permissions
  end
  
  def create
    @status = IssueStatus.new issue_statuses_params
    
    if @status.save
      redirect_to (params[:refer].presence || [:settings, @status])
    else
      render :template => 'settings/issue_statuses/new'
    end
  end
  
  def edit
    @status = IssueStatus.find(params[:id])
    @status.prepare_group_permissions
  end
  
  def update
    @status = IssueStatus.find(params[:id])
    if @status.update_attributes(issue_statuses_params)
      redirect_to (params[:refer].presence || [:settings, @status])
    else
      render :template => 'settings/issue_statuses/edit'
    end
    
  end
  
  private
  def issue_statuses_params
    params.require(:issue_status).permit(:name, :order, :mode,
      :issue_status_permissions_attributes => [
        :id, 
        :group_id, :view_issue, :create_issue, :edit_issue, :fill_up_values,
        :submit_values, :delete_issue, :issue_status_ids => []])
  end
end
