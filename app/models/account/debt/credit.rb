# frozen_string_literal: true

##
# Account::Debt::Credit represents a credit account in the archive. This usually means any kind of credit line a bank
# might approve you or credit card.
class Account::Debt::Credit < Account
  include Account::WithHistory, Account::IsNonCategory
end
