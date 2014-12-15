require 'filters/base'

module Pigeon
  module Filters
    class SampleFilter < Pigeon::Filter::Base
      def filter(query)
        query = keyword_filter(query) if q
        query
      end
      
      def keyword_filter(query)
        query.where(:no => q)
      end
    end
  end
end
