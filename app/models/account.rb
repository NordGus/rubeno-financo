# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :archive, inverse_of: :accounts
  belongs_to :parent, optional: true, class_name: "Account", foreign_key: :parent_id

  has_many :children, class_name: "Account", foreign_key: :parent_id, dependent: :destroy

  validate :parent_is_not_account_system_history

  private

  def parent_is_not_account_system_history
    return unless parent.present?
    return unless parent.type == "Account::System::History"

    errors.add(:parent, "can't be a system history account")
  end
end
