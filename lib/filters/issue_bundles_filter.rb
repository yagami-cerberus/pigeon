require 'filters/base'

module Pigeon
  module Filters
    class IssueBundlesFilter < Pigeon::Filter::Base
      # bundle_id, status_id
      attr_accessor :s, :b
      
      def filter(query)
        query = status_filter(query) if self.s
        query = bundle_filter(query) if self.b
        query
      end
      
      def keyword_filter(query)
        kw = q.strip
        
        if not kw.empty?
          query = query.where(:inspection_bundles => {:title => kw})
        end
        
        query
      end
      
      def bundle_filter(query)
        query.where :inspection_bundle_id => b
      end
      
      def status_filter(query)
        query.status self.s
      end
    end
  end
end
