# frozen_string_literal: true

##
# Account::System::History is an account used to represent the balance of the parent account at a certain date, this is
# one is used to include it on the archive's ledger(s).
class Account::System::History < Account
  belongs_to :parent, class_name: "Account", foreign_key: :parent_id
end
