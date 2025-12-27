# frozen_string_literal: true

##
# Account::Category::Expense represents an expense account or an family of expense accounts in the archive, like "Food",
# "Transport", "Groceries", etc.
class Account::Category::Expense < Account
  include Account::IsCategory, WithFileSystem

  has_many :children, class_name: "Account::Category::Expense", foreign_key: :parent_id, dependent: :destroy
end
