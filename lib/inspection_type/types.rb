module Pigeon
  module InspectionType
    module NumericExtend
      def NumericExtend.included(klass)
        def klass.add_numeric_piar *prefix
          prefix.each do |p|
            p = "#{p}_" unless p.empty?

            class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
            attr_accessor :#{p}lowerbound, :#{p}lowerbound_op
            attr_accessor :#{p}upbound, :#{p}upbound_op

            validates :#{p}lowerbound_op, inclusion: { in: %w(g ge), allow_nil: true }
            validates :#{p}upbound_op, inclusion: { in: %w(l le), allow_nil: true }
            validates :#{p}lowerbound, numericality: true, if: :#{p}lowerbound_op
            validates :#{p}upbound, numericality: true, if: :#{p}upbound_op

            before_validation do
              unless self.#{p}lowerbound_op.present?
                self.#{p}lowerbound = nil
                self.#{p}lowerbound_op = nil
              end
              unless self.#{p}upbound_op.present?
                self.#{p}upbound = nil
                self.#{p}upbound_op = nil
              end
            end

            def in_#{p}range?(value)
              (numeric_operation(#{p}lowerbound.to_f, #{p}lowerbound_op, value) &&
                numeric_operation(#{p}upbound.to_f, #{p}upbound_op, value))
            end

            def inject_#{p}range(symbol = "value")
              l_op = {'ge' => '≤', 'g' => '<'}[#{p}lowerbound_op]
              u_op = {'le' => '≤', 'l' => '<'}[#{p}upbound_op]
              
              "\#{#{p}lowerbound} \#{l_op} \#{symbol} \#{u_op} \#{#{p}upbound}"
            end
            RUBY_EVAL
          end
        end

        def numeric_operation(left, operator, right)
          case operator
          when 'ge'
            left <= right
          when 'g'
            left < right
          when 'le'
            left >= right
          when 'l'
            left > right
          else
            true
          end
        end

        def try_parse_value(value, on_failed)
          if /\A(-)?\d+(\.\d+)?\z/ =~ value
            yield value.to_f
          elsif /\A<(=)?(-)?\d+(\.\d+)?\z/ =~ value
            yield -Float::MAX
          elsif /\A>(=)?(-)?\d+(\.\d+)?\z/ =~ value
            yield Float::MAX
          else
            on_failed
          end
        end
      end
    end

    class Base
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include ActiveModel::Conversion
      include ActiveModel::Serialization

      def initialize(params = {})
        params.each do |attr, value|
          self.public_send("#{attr}=", value) if self.respond_to?"#{attr}="
        end if params
      end

      def in_limitation(value)
        true
      end

      def value_error?(value, options = {})
        false
      end

      def describe
        '??'
      end
    end

    class NumericType < Base
      include NumericExtend
      add_numeric_piar 'limit', ''

      def data_type
        :text
      end

      def in_limitation(value)
        try_parse_value(value, on_failed: true) { |v| in_limit_range?(v) }
      end

      def value_error?(value, options = {})
        !try_parse_value(value, on_failed: true) { |v| in_range?(v) }
      end

      def describe
        inject_range
      end
    end

    class NumericWithSexType < Base
      include NumericExtend
      add_numeric_piar 'limit', 'male', 'female'
      
      def data_type
        :text
      end

      def in_limitation(value)
        try_parse_value(value, on_failed: true) { |v| in_limit_range?(v) }
      end

      def value_error?(value, options = {})
        if options[:sex] == 'male'
          !try_parse_value(value, on_failed: true) { |v| in_male_range?(v) }
        elsif options[:sex] == 'female'
          !try_parse_value(value, on_failed: true) { |v| in_female_range?(v) }
        else
          true
        end
      end

      def describe
        "Male: #{inject_male_range}/Female #{inject_female_range}"
      end
    end

    class TextType < Base
      def data_type
        :text
      end
      
      def describe
        "Text"
      end
    end
    
    class EnumType < Base
      attr_accessor :options

      def data_type
        :text
      end

      def describe
        "Selection: %s" % options
      end

      def items
        options.split(",")
      end
    end

    class PositiveNegativeType < Base
      attr_accessor :normal_reaction

      def data_type
        :text
      end

      def positive
        "+"
      end

      def negative
        "-"
      end

      def value_error?(value, options = {})
        value != normal_reaction
      end

      def describe
        case normal_reaction
        when '+'
          "*Positive/Negative"
        when '-'
          "Positive/*Negative"
        else
          "Positive/Negative"
        end
      end
    end
  end
end
