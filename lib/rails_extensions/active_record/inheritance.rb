# frozen_string_literal: true

require "active_record"

module ActiveRecord
  module Inheritance
    module ClassMethods
      def polymorphic_name
        ActiveRecord::Base.store_base_sti_class ? base_class.name : name
      end
    end
  end
end
