require "#{Rails.root}/lib/rails_extensions/active_record/store_sti_base_class"

# Makes ActiveRecord store the STI class name instead of the base class name in the database for polymorphic associations.
ActiveRecord::Base.store_base_sti_class = false
