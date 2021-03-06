require 'filters/issue_filter'
require 'irb'

class IssuesController < ApplicationController
  def index
    @filter = Pigeon::Filters::IssueFilter.new params[:filter]
    issues = Issue.viewable(claims).includes(:profile, :issue_status)
    @current_page, @page_size, @issues = @filter.paginate(@filter.filter(issues), params[:p])
  end

  def new
    @issue = Issue.new

    if params[:profile_id].present?
      @issue.profile = Profile.find(params[:profile_id])
    else
      @issue.profile = Profile.new
    end
  end

  def create
    @issue = Issue.new issue_params
    @issue.created_by = claims.model
    @issue.issue_status = IssueStatus.permit_with(claims, 'issue.create').find_by_id(params[:issue_status_id])

    if @issue.save
      redirect_to issue_path(@issue)
    else
      render :template => 'issues/new'
    end
  end
  
  def show
    @issue = Issue.includes(:profile, :issue_status, :issue_bundles).find(params[:id])
  end
  
  def edit
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])
    @issue.assign_attributes issue_params

    if @issue.save
      redirect_to issue_path(@issue)
    else
      render :template => 'issues/edit'
    end
  end

  def update_status
    status_id = params[:status]
    issue = Issue.find(params[:id])
    status = IssueStatus.find status_id
    if claims.can_update_issue_status_to(issue).include?(status.id)
      issue.update_attribute(:issue_status_id, status_id)
      flash[:success] = t :'issue.change_status_success', :status => status.name
    else
      flash[:error] = t :'access_deny'
    end
    redirect_to issue_path(issue)
  end

  def sample_tmpl
    sample = Sample.new
    render :partial => 'issues/sample_tmpl', :locals => {object: sample, form_prefix: params[:form_prefix] || ''}
  end

  def bundle_tmpl
    b = InspectionBundle.find(params[:id])
    ib = IssueBundle.new(inspection_bundle: b)
    form_prefix = "#{params[:form_prefix]}[#{params[:id]}]"
    render :partial => 'issues/bundle_tmpl', :locals => {object: ib, form_prefix: form_prefix}
  end

  def search_bundle
    if params[:q].present?
      records = InspectionBundle.where('code LIKE :kw', :kw => "#{params[:q]}%")
      datas = records.map do |b|
        {:id => b.id, :text => "[#{b.code}] #{b.title}"}
      end
      
      render :json => datas
    else
      render :json => []
    end
  end

  private
  def issue_params
    issue_params = params.require(:issue)
    if issue_params[:profile_id].present?
      issue_params.permit(
        :profile_id,
        :issue_bundles_attributes => [:id, :inspection_bundle_id, :_destroy, :inspection_item_ids => []],
        :samples_attributes => [:id, :no, :sample_type, :quantity, :_destroy])
    else
      issue_params.permit(
        :profile_attributes => [:identify, :firstname, :surname, :birthday, :sex],
        :issue_bundles_attributes => [:id, :inspection_bundle_id, :_destroy, :inspection_item_ids => []],
        :samples_attributes => [:id, :no, :sample_type, :quantity, :_destroy])
    end
  end
end
