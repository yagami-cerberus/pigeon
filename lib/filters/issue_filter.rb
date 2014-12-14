require 'filters/base'

module Pigeon
  module Filters
    class IssueFilter < Pigeon::Filter::Base
      attr_accessor :s

      def initialize(params = {})
        super params
        self.s = "processing" unless self.s
      end
      
      def filter(query)
        query = issue_status_filter(query)
      end
      
      def issue_status_filter(q)
        if s == "processing"
          return q.processing
        elsif s == "finished"
          return q.finished
        else
          return q.status_equal s
        end
      end
    end
  end
end
