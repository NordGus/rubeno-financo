# frozen_string_literal: true

##
# Account::Capital module represents the group of capital accounts in the archive. Accounts like, checking, cash,
# savings and/or any other source of capital to be defined.
module Account::Capital
  def self.table_name_prefix
    "account_capital_"
  end
end
