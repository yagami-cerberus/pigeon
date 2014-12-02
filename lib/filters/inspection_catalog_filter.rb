require 'filters/base'

module Pigeon
  module Filters
    class InspectionCatalogFilter < Pigeon::Filter::Base
      attr_accessor :group
      
      def filter(query)
        query = keyword_filter(query) if q.presence
        query = group_filter(query) if group.presence
        query
      end
      
      def keyword_filter(query)
        kw = q.strip
        
        if not kw.empty?
          param = "%#{kw}%"
          query.where('title like ? OR code like ?', param, param)
        end
        
        query
      end
      
      def group_filter(query)
        query.where :group_name => group
      end
    end
  end
end
