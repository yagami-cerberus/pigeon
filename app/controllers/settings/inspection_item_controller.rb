require 'filters/inspection_catalog_filter'

class Settings::InspectionItemController < ApplicationController
  before_action -> {
    claims.permit! :system, 'admin.manage_products'
  }

  UPDATE_ITEM_FIELDS = [:title, :group_name, :sample_type, :code]

  def index
    @filter = Pigeon::Filters::InspectionCatalogFilter.new(params[:filter])
    @current_page, @page_size, @items = 
      @filter.paginate(@filter.filter(InspectionItem.all), params[:p])
  end
  
  def show
    @item = InspectionItem.find(params[:id])
  end
  
  def new
    @item = InspectionItem.new
  end
  
  def create
    @item = InspectionItem.new params.require(:inspection_item).permit(UPDATE_ITEM_FIELDS)
    
    if @item.save
      redirect_to [:settings, @item]
    else
      render :template => 'settings/inspection_item/new'
    end
  end
  
  def edit
    @item = InspectionItem.find(params[:id])
  end
  
  def update
    @item = InspectionItem.find(params[:id])
    if @item.update_attributes(params.require(:inspection_item).permit(UPDATE_ITEM_FIELDS))
      redirect_to (params[:refer].presence || @item)
    else
      render :template => 'inspection_item/edit'
    end
  end
end
