module BitFlags
  extend ActiveSupport::Concern

  included do
  end
  
  module ClassMethods
    def bit_flags column, map
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{column}_map
        #{map.invert}
      end
      
      def #{column}_items
        @_#{column}_items ||= 63.times.map {|o| 1 << o}.delete_if { |b| #{column} & b == 0}
      end
      
      def #{column}_items=(value)
        self.#{column} = 0
        value.each { |b| self.#{column} |= b.to_i }
      end
      
      def #{column}=(value)
        @_#{column}_items = nil
        write_attribute(:#{column}, value)
      end
      
      def #{column}
        value = read_attribute(:#{column})
        value == nil ? 0 : value
      end
      RUBY_EVAL
      
      map.each do |offset, label|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{label}
          self.#{column} = 0 unless self.#{column}.kind_of?(Integer)
          (self.#{column} & #{1 << offset}) > 0
        end
        
        def #{label}=(value)
          self.#{column} = 0 unless self.#{column}.kind_of?(Integer)
          value = false if value == "0" || value == "false"
          
          if value && (value != "0" || value != "false")
            self.#{column} |= #{1 << offset}
          else
            self.#{column} = (self.#{column} | #{1 << offset}) ^ #{1 << offset}
          end
        end
        RUBY_EVAL
      end
    end
  end
end
