# frozen_string_literal: true

##
# Account::Debt::Loan represents a loan account in the archive, this usually means any kind of normal loan someone can
# contract, like personal debt to a friend, a loan to upgrade something at home, a car loan, student loan, etc.
class Account::Debt::Loan < Account
  include Account::WithHistory, Account::IsNonCategory
end
