require 'filters/issue_bundles_filter'

class IssueBundlesController < ApplicationController
  def index
    @status = IssueStatus.processing.where(:id => claims.issue_status_id_for('inspection.view'))
    @bundles = Hash[ *InspectionBundle.group_names.map { |gn|
      [gn, InspectionBundle.where(:group_name => gn)]
    }.flatten(1) ]
    @statistics = load_statistics @status.pluck :id
  end
  
  def search
    @filter = Pigeon::Filters::IssueBundlesFilter.new(params[:filter])
    @bundles = @filter.filter(IssueBundle.includes(:issue).all)
  end
  
  def show
    @bundle = IssueBundle.find(params[:id])
  end
  
  def update
    bundle = IssueBundle.find(params[:id])

    if bundle.can_update?(claims)
      editor = claims.model

      counter = 0
      params[:item].each do |atom_id, payload|
        a = bundle.issue_values.find_by_id(atom_id)
        counter += 1 if a.update_value(payload, editor) if a
      end if params[:item]

      # TODO: localize message
      flash[:success] = "#{counter} value updated."
    end

    if bundle.can_lock?(claims) && params[:operation] == 'submit'
      bundle.update_attribute('locked', true)
    end

    if bundle.can_unlock?(claims) && params[:operation] == 'rollback'
      bundle.update_attribute('locked', false)
    end

    redirect_to issue_bundle_path(bundle)
  end
  
  private
  def load_statistics issues_status_ids
    status_maps = IssueBundle.
      joins(:issue).
      where(:issues => {:issue_status_id => issues_status_ids}).
      group("issues.issue_status_id", "issue_bundles.inspection_bundle_id").
      pluck("issue_bundles.inspection_bundle_id", "issues.issue_status_id", "count(issue_bundles.id)")
    
    bundle_statistics = {}
    status_maps.each do |m|
      bundle_id, status_id, count = m
      b = bundle_statistics[bundle_id] ||= {}
      b[status_id] = count
    end
    bundle_statistics
  end
end
