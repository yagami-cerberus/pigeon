require 'filters/inspection_bundle_filter'

class Settings::InspectionBundleController < ApplicationController
  default_access_control 'admin.manage_products'
  
  def index
    @filter = Pigeon::Filters::InspectionBundleFilter.new params[:filter]
    @current_page, @page_size, @bundles =
      @filter.paginate @filter.filter(InspectionBundle.all), params[:p]
  end
  
  def new
    @bundle = InspectionBundle.new
  end
  
  def create
    @bundle = InspectionBundle.new bundle_params
    if @bundle.save
      redirect_to params[:refer] || settings_inspection_bundle_index_path
    else
      render :template => 'settings/inspection_bundle/new'
    end
  end
  
  def edit
    @bundle = InspectionBundle.find(params[:id])
  end
  
  def update
    @bundle = InspectionBundle.find(params[:id])
    if @bundle.update_attributes bundle_params
      redirect_to (params[:refer].presence || settings_inspection_bundle_index_path)
    else
      render :template => 'settings/inspection_bundle/edit'
    end
  end
  
  private
  def bundle_params
    data = params.require(:inspection_bundle).permit(:title, :code, :group_name, :item_ids => [])
    data[:item_ids] = [] unless data[:item_ids]
    data
  end
end
