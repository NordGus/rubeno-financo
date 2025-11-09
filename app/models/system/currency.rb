# frozen_string_literal: true

class System::Currency
  ALL = %w[ multi usd eur gbp ].index_by(&:itself).freeze
  FOR_CATEGORIES = %w[ multi ].index_by(&:itself).freeze
  FOR_ACCOUNTS = %w[ usd eur gbp ].index_by(&:itself).freeze
  FOR_TRANSACTIONS = FOR_ACCOUNTS
end
