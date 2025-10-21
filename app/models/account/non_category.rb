# frozen_string_literal: true

##
# Account::NonCategory is a concern to indicate that an account operates on real currencies with valid [ISO 4217](https://en.wikipedia.org/wiki/ISO_4217)
# currency code, and does not use the internal "multi" code use for categorization accounts.
module Account::NonCategory
  extend ActiveSupport::Concern

  included do
    enum :currency, %w[ usd eur gbp ].index_by(&:itself), prefix: :operates_in
  end
end
