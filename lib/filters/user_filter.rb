require 'filters/base'

module Pigeon
  module Filters
    class UserFilter < Pigeon::Filter::Base
      attr_accessor :disabled, :reviewing
      
      def filter(query)
        query = disabled_filter(query) if disabled.presence
        query = keyword_filter(query) if q.presence
        query
      end
      
      def keyword_filter(query)
        kw = q.strip
        
        if not kw.empty?
          param = "%#{kw}%"
          query.where('name like ? OR username like ? OR email like ?', param, param, param)
        end
        
        query
      end
      
      def disabled_filter(query)
        case disabled
        when 't'
          query.disabled?(true)
        when 'f'
          query.disabled?(false)
        else
          query
        end
      end
    end
  end
end
