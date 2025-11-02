# frozen_string_literal: true

class CreateAccountConfigHistories < ActiveRecord::Migration[8.1]
  def change
    create_table(
      :account_config_histories,
      comment: "Contains the configuration for history accounts. This is used to create a single transaction between "\
        "the history account and its parent to mark the initial balance of said parent account on the archive's "\
        "ledger(s)."
    ) do |t|
      t.belongs_to(
        :account,
        null: false,
        foreign_key: {
          to_table: :accounts
        }
      )
      t.decimal(
        :balance,
        precision: 16,
        scale: 2,
        default: 0.0,
        comment: "Balance of the history account's parent at the given date. This value is gonna be used to create a "\
          "transaction between the history account and its parent to put mark the initial balance of the account on "\
          "the archive's ledger(s)."
      )
      t.date(
        :at,
        null: true,
        comment: "Date of the balance of the history account's parent. This value is gonna be used to create a "\
          "transaction between the history account and its parent to put mark the initial balance of the account on "\
          "the archive's ledger(s)."
      )

      t.timestamps
    end
  end
end
