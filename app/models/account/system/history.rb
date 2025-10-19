# frozen_string_literal: true

##
# Account::System::History is an account used to represent the balance of the parent account at a certain date, this is
# one is used to include it on the archive's ledger(s).
class Account::System::History < Account
  FIXED_NAME = "History"
  # This string is written this way to separated into multiple lines while being stored as a contiguous string by
  # the constant
  FIXED_DESCRIPTION = "DO NOT DELETE! "\
    "This is an account generated automatically by financo. "\
    "It is used for the internals of the application, "\
    "financo controls its life-cycle."\
    "DO NOT DELETE!"

  belongs_to :parent, class_name: "Account", foreign_key: :parent_id

  normalizes :name, with: ->(_name) { FIXED_NAME }, apply_to_nil: true
  normalizes :description, with: ->(_description) { FIXED_DESCRIPTION }, apply_to_nil: true
end
