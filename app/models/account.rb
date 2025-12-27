# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :archive, inverse_of: :accounts
  belongs_to :parent, optional: true, class_name: "Account", foreign_key: :parent_id

  # children is the association used to build the account tree.
  has_many :children, class_name: "Account", foreign_key: :parent_id, dependent: :destroy
  # children_in_system is the same association as children but only contains accounts that are not softly deleted.
  has_many :children_in_system, -> { in_system }, class_name: "Account", foreign_key: :parent_id, dependent: :destroy

  has_many :credit_transactions, class_name: "Transaction", foreign_key: :to_id, inverse_of: :to, dependent: :destroy
  has_many :debit_transactions, class_name: "Transaction", foreign_key: :from_id, inverse_of: :from, dependent: :destroy
  has_many :child_credit_transactions, class_name: "Transaction", foreign_key: :to_parent_id, inverse_of: :to, dependent: :destroy
  has_many :child_debit_transactions, class_name: "Transaction", foreign_key: :from_parent_id, inverse_of: :from, dependent: :destroy

  has_one :file_system, class_name: "FileSystem::Item::Mount", as: :parentable, dependent: :destroy

  def transactions
    Transaction.where(from_id: id)
               .or(Transaction.where(to_id: id))
               .or(Transaction.where(from_parent_id: id))
               .or(Transaction.where(to_parent_id: id))
               .order(executed_at: :desc)
  end

  enum :currency, ::System::Currency::ALL, prefix: :operates_in

  scope :active, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :parents_only, -> { includes(:children).where(parent_id: nil) }
  scope :current, -> { where(archive: Current.archive) }
  # in_system is a scope that only returns accounts that are not softly deleted.
  scope :in_system, -> { where(deleted_at: nil) }

  validate :parent_is_not_account_system_history

  def full_name
    return name unless parent_id.present?

    "#{parent.name} (#{name})"
  end

  ##
  # Soft deletes the account and all associated records that are dependent on it (as the account sits on top of the
  # association tree). Then enqueues a background job to destroy the account and dependent records. This allows financo
  # to quickly remove accounts or records from the UI while running the slow and heavy destroy operations in the
  # background.
  #
  def soft_destroy
    timestamp = Time.current
    success = nil

    transaction do
      children.update_all(deleted_at: timestamp)
      child_credit_transactions.update_all(deleted_at: timestamp)
      child_debit_transactions.update_all(deleted_at: timestamp)
      credit_transactions.update_all(deleted_at: timestamp)
      debit_transactions.update_all(deleted_at: timestamp)
      file_system.soft_destroy!
      success = update!(deleted_at: timestamp)
      Cleanup::DestroySoftDeletedRecordJob.perform_later(self)
    end

    success
  end

  private

  def parent_is_not_account_system_history
    return unless parent.present?
    return unless parent.type == "Account::System::History"

    errors.add(:parent, "can't be a system history account")
  end
end
