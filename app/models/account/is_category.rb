# frozen_string_literal: true

##
# Account::IsCategory is a concern to indicate that an account represents a category of expenses or incomes, that only
# operates with the currency code "multi", these are mostly categorization accounts, like "Food", "Transport", "Groceries",.
module Account::IsCategory
  extend ActiveSupport::Concern

  included do
    enum :currency, ::System::Currency::FOR_CATEGORIES, prefix: :operates_in

    validate :child_has_the_same_currency_as_parent
    validate :child_is_the_same_type_as_parent

    accepts_nested_attributes_for :children_in_system, allow_destroy: false
  end

  class_methods do
    private

    def children_has_the_same_currency_as_parent
      return unless parent.present?

      errors.add(:currency, "must match parent currency") unless parent.currency == currency
    end

    def child_is_the_same_type_as_parent
      return unless parent.present?

      errors.add(:type, "must match parent type") unless parent.type == type
    end
  end
end
