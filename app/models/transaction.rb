# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :archive, class_name: "Archive", inverse_of: :transactions, foreign_key: :archive_id
  belongs_to :from, class_name: "Account", inverse_of: :debit_transactions, foreign_key: :from_id
  belongs_to :to, class_name: "Account", inverse_of: :credit_transactions, foreign_key: :to_id

  # from_parent and to_parent are optional relations to denormalize the relation between from and to account for eager
  # loading data optimization.
  belongs_to :from_parent, class_name: "Account", inverse_of: :child_debit_transactions, foreign_key: :from_parent_id, optional: true
  belongs_to :to_parent, class_name: "Account", inverse_of: :child_credit_transactions, foreign_key: :to_parent_id, optional: true

  # using before_validation ease the cognitive load when creating or updating the transaction.
  before_validation lambda { |record| record.from_parent_id = record.from.parent_id }
  before_validation lambda { |record| record.to_parent_id = record.to.parent_id }

  validate :from_parent_id_must_match_from_parent_id
  validate :to_parent_id_must_match_to_parent_id

  def soft_delete
  end

  enum :currency, %w[ usd eur gbp ].index_by(&:itself), prefix: :operates_in

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

  def from_parent_id_must_match_from_parent_id
    errors.add(:from_parent, "must match from account parent_id") if from_parent_id != from.parent_id
  end

  def to_parent_id_must_match_to_parent_id
    errors.add(:to_parent, "must match to account parent_id") if to_parent_id != to.parent_id
  end
end
