require 'inspection_type/manager'

class InspectionAtom < ActiveRecord::Base
  belongs_to :inspection_item
  default_scope { order('order_index ASC') }
  
  def self.type_manager
    @@_type_manager ||= Pigeon::InspectionType::Manager.instance
  end
  
  def type_handler
    @@_type_manager ||= Pigeon::InspectionType::Manager.instance
    if data_type.present?
      @@_type_manager.get_type_by_name(data_type).new JSON.parse(data_descriptor)
    else
      @@_type_manager.get_type_by_name('numeric').new
    end
  end

  def value_error?(data)
    type_handler.value_error? data
  end
end
