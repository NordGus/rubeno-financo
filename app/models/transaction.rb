# frozen_string_literal: true

##
# Transaction represents a money movement entry in the archive's ledger. It also works as the edges of the financial
# graph it makes with all the accounts, where accounts are the nodes. This is done to build powerful visualizations
# later on.
class Transaction < ApplicationRecord
  has_rich_text :notes, store_if_blank: false

  belongs_to :archive, class_name: "Archive", inverse_of: :transactions, foreign_key: :archive_id
  belongs_to :from, class_name: "Account", inverse_of: :debit_transactions, foreign_key: :from_id
  belongs_to :to, class_name: "Account", inverse_of: :credit_transactions, foreign_key: :to_id

  # from_parent and to_parent are optional relations to denormalize the relation between from and to account for eager
  # loading data optimization.
  belongs_to :from_parent, class_name: "Account", inverse_of: :child_debit_transactions, foreign_key: :from_parent_id, optional: true
  belongs_to :to_parent, class_name: "Account", inverse_of: :child_credit_transactions, foreign_key: :to_parent_id, optional: true

  # using before_validation ease the cognitive load when creating or updating the transaction.
  before_validation :set_or_update_adjust_transaction_direction_before_validation
  before_validation :set_or_update_populate_parents_before_validation

  validates_presence_of :from, :to, :from_amount, :to_amount, :currency, :issued_at

  validate :from_parent_id_must_match_from_account_parent_id
  validate :to_parent_id_must_match_to_account_parent_id
  # A transaction cannot introduce a cycle in the graph, meaning that from and to cannot be the same account.
  validates :to_id, comparison: { other_than: :from_id }
  # A transaction does not store the sign of the amount, instead it is inferred from the relation between from and to
  # accounts, so we have to validate that both from_amount and to_amount are positive.
  validates :from_amount, numericality: { greater_than: 0 }
  validates :to_amount, numericality: { greater_than: 0 }
  # Einstein said time travel is impossible. So no fun allowed
  validates :executed_at, comparison: { greater_than_or_equal_to: :issued_at }

  default_scope { includes(:from, :to, :from_parent, :to_parent) }
  scope :in_system, -> { where(deleted_at: nil) }
  scope :executed, -> { where.not(executed_at: nil).order(executed_at: :desc) }
  scope :pending, -> { where(executed_at: nil).order(issued_at: :desc) }

  enum :currency, ::System::Currency::FOR_TRANSACTIONS, prefix: :operates_in

  def soft_destroy
    timestamp = Time.current
    success = nil

    transaction do
      success = update!(deleted_at: timestamp)

      Cleanup::DestroySoftDeletedRecordJob.perform_later(self)
    end

    success
  end

  private

  def set_or_update_populate_parents_before_validation
    return unless from_id.present? && to_id.present?

    self.from_parent_id = from.parent_id
    self.to_parent_id = to.parent_id
  end

  def set_or_update_adjust_transaction_direction_before_validation
    return unless from_amount.present? && to_amount.present?
    return unless from_id.present? && to_id.present?
    return unless from_amount < 0 || to_amount < 0

    self.from_parent_id, self.to_parent_id = self.to.parent_id, self.from.parent_id
    self.from, self.to = self.to, self.from
    self.from_amount, self.to_amount = self.to_amount.abs, self.from_amount.abs
  end

  def from_parent_id_must_match_from_account_parent_id
    errors.add(:from_parent, "must match from account parent_id") if from_parent_id != from.parent_id
  end

  def to_parent_id_must_match_to_account_parent_id
    errors.add(:to_parent, "must match to account parent_id") if to_parent_id != to.parent_id
  end
end
