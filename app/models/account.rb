# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :archive, inverse_of: :accounts
  belongs_to :parent, optional: true, class_name: "Account", foreign_key: :parent_id

  has_many :children, class_name: "Account", foreign_key: :parent_id, dependent: :destroy

  enum :currency, %w[ multi usd eur gbp ].index_by(&:itself), prefix: :operates_in

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :parents_only, -> { includes(:children).where(parent_id: nil) }
  scope :current, -> { where(archive: Current.archive) }

  validate :parent_is_not_account_system_history

  def full_name
    return name unless parent_id.present?

    "#{parent.name} (#{name})"
  end

  private

  def parent_is_not_account_system_history
    return unless parent.present?
    return unless parent.type == "Account::System::History"

    errors.add(:parent, "can't be a system history account")
  end
end
