# frozen_string_literal: true

##
# Account::Capital::Checking represents a checking account in the archive, this usually means a bank account someone
# uses for their day to day uses.
class Account::Capital::Checking < Account
  include Account::WithHistory, Account::IsNonCategory
end
