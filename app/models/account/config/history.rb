# frozen_string_literal: true

##
# Account::Config::History represents the configuration of the history account. This is done to implement different
# polymorphic behaviors depending on the history account's parent type, to create a single history transaction.
class Account::Config::History < ApplicationRecord
  belongs_to :account, class_name: "Account::System::History", inverse_of: :config
end
