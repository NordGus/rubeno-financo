# frozen_string_literal: true

##
# Account::Capital::Saving represent a liquid savings account in the archive, mostly savings bank accounts.
class Account::Capital::Saving < Account
  include Account::WithHistory, Account::IsNonCategory
end
