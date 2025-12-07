# frozen_string_literal: true

require "active_record"

module ActiveRecord
  class Base
    class_attribute :store_base_sti_class
    self.store_base_sti_class = true
  end
end
