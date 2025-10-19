# frozen_string_literal: true

##
# Account::WithHistory is a concern to indicate that an account has a child history account to mark the initial balance
# of the account.
module Account::WithHistory
  include ActiveSupport::Concern

  included do
    has_one :history, class_name: "Account::System::History", foreign_key: :parent_id, dependent: :destroy
  end
end
