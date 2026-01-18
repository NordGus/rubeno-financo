# frozen_string_literal: true

##
# Account::Category::Income represents an income account or an family of income accounts in the archive, like "Salary",
# "Bonus", "Interest", etc.
class Account::Category::Income < Account
  include Account::IsCategory, WithFileSystem

  has_many :children, class_name: "Account::Category::Income", foreign_key: :parent_id, dependent: :destroy
end
