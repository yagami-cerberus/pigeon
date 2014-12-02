require 'singleton'
require 'inspection_type/types'

module Pigeon
  module InspectionType
    class Manager
      include Singleton
      
      def initialize
        @types = {
          'numeric' => Pigeon::InspectionType::NumericType,
          'numeric_with_sex' => Pigeon::InspectionType::NumericWithSexType,
          'text' => Pigeon::InspectionType::TextType,
          'enum' => Pigeon::InspectionType::EnumType,
          'positive_negative' => Pigeon::InspectionType::PositiveNegativeType
        }
      end
      
      def regist(name, klass)
        @types[name] = klass
      end
      
      def map
        @types.map { |t|
          yield t
        }
      end
      
      def get_name_by_instance(instance)
        @types.key(instance.class)
      end
      
      def get_type_by_name(name)
        @types[name] || raise("%s not found" % name)
      end
    end
  end
end