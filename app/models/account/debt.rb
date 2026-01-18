# frozen_string_literal: true

##
# Account::Debt module represents the group of debt accounts or passives in the archive. Accounts like personal or
# family loans, credit lines or credit cards, or any other source of debt to be defined.
module Account::Debt
  def self.table_name_prefix
    "account_debt_"
  end
end
