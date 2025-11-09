# frozen_string_literal: true

##
# Account::IsNonCategory is a concern to indicate that an account operates on real currencies with valid [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217)
# currency code, and does not use the internal "multi" code use for categorization accounts.
module Account::IsNonCategory
  extend ActiveSupport::Concern

  included do
    enum :currency, ::System::Currency::FOR_ACCOUNTS, prefix: :operates_in

    validate :child_has_the_same_currency_as_parent
  end

  class_methods do
    private

    def children_has_the_same_currency_as_parent
      return unless parent.present?

      errors.add(:currency, "must match parent currency") unless parent.currency == currency
    end
  end
end
