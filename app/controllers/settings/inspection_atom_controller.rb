class Settings::InspectionAtomController < ApplicationController
  before_action -> {
    claims.permit! :system, 'admin.manage_products'
  }

  def new
    @atom = InspectionAtom.new
    @type_handler = @atom.type_handler
  end
  
  def create
    @atom = InspectionAtom.new inspection_item_fields
    @type_handler = load_data_type_from_params
    
    @atom.inspection_item_id = params[:inspection_item_id]
    @atom.data_descriptor = @type_handler.to_json
    
    if @type_handler.valid? && @atom.valid?
      @atom.save!
      redirect_to settings_inspection_item_path(@atom.inspection_item)
    else
      render :template => 'settings/inspection_item/new'
    end
  end
  
  def edit
    @atom = InspectionAtom.find(params[:id])
    @type_handler = @atom.type_handler
  end
  
  def update
    @atom = InspectionAtom.find(params[:id])
    @type_handler = load_data_type_from_params
    
    @atom.assign_attributes(inspection_item_fields)
    @atom.data_descriptor = @type_handler.to_json
    
    if @type_handler.valid? && @atom.valid?
      @atom.save!
      redirect_to settings_inspection_item_path(@atom.inspection_item)
    else
      render :template => 'settings/inspection_item/edit'
    end
  end
  
  def type_tmpl
    @type_handler = InspectionAtom.type_manager.get_type_by_name(params[:name]).new
    render :partial => "settings/inspection_atom/handler_template"
  rescue
    render :text => "\xe9\xbb\x92\xe7\x8c\xab\xe3\x81\xaf\xe4\xbf\xba\xe3\x81\xae\xe5\xab\x81"
  end
  
  private
  def inspection_item_fields
    params.require(:inspection_atom).permit([:title, :code, :unit, :order_index, :program_code, :data_type])
  end
  
  def load_data_type_from_params
    type_name = params[:inspection_atom][:data_type]
    type_options = params[:inspection_atom][:type_handler]
    InspectionAtom.type_manager.get_type_by_name(type_name).new(type_options)
  end
end
