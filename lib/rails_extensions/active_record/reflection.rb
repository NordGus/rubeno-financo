# frozen_string_literal: true

require "active_record"

module ActiveRecord
  module Reflection
    class PolymorphicReflection
      def source_type_scope
        type = @previous_reflection.foreign_type
        source_type = @previous_reflection.options[:source_type]

        # START PATCH
        adjusted_source_type =
          if ActiveRecord::Base.store_base_sti_class
            source_type
          else
            ([ source_type.constantize ] + source_type.constantize.descendants).map(&:to_s)
          end
        # END PATCH

        lambda { |object| where(type => adjusted_source_type) }
      end
    end
  end
end
