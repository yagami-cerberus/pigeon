module ApplicationHelper
  def render_page_number(page, enabled: true, actived: false, symbol: nil)
    render :partial => 'layouts/pagination/page_number', :locals => {page: page, enabled: enabled, actived: actived, symbol:symbol}
  end
  
  def inspection_type_editor(field, instance)
    cls_name = InspectionAtom.type_manager.get_name_by_instance instance
    render :partial => "layouts/inspection_type/editors/#{cls_name}", :locals => {:f => field}
  end

  def inspection_type_field(instance, field_prefix)
    handler = instance.type_handler
    cls_name = InspectionAtom.type_manager.get_name_by_instance handler
    render :partial => "layouts/inspection_type/fields/#{cls_name}", :locals => {
      :instance => instance, :handler => handler, :prefix => field_prefix}
  end
end
