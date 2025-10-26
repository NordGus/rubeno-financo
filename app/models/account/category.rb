# frozen_string_literal: true

##
# Account::Category is a module that represents the group of category accounts in the archive like "Food", "Transport"
# or "Paycheck".
module Account::Category
  def self.table_name_prefix
    "account_category_"
  end
end
