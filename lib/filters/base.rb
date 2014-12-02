module Pigeon
  module Filter
    class Base
      attr_accessor :q
  
      def initialize(params = {})
        params.each do |attr, value|
          self.public_send("#{attr}=", value)
        end if params
      end
      
      def paginate(query, page, per_page = 40)
        current_page = page.to_i
        page_size = (query.count.to_f / per_page).ceil
        [current_page, page_size,  query.offset(40 * current_page).limit(per_page)]
      end
    end
  end
end
