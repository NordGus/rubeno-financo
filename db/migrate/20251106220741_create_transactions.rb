class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.belongs_to(
        :archive,
        null: false,
        foreign_key: { to_parent: :archives, name: :transactions_archive_fk },
        comment: "The archive that the transaction belongs to."
      )
      t.belongs_to(
        :from,
        null: false,
        foreign_key: { to_table: :accounts, name: :transactions_from_account_fk },
        comment: "The account where the transaction is coming from."
      )
      t.belongs_to(
        :to,
        null: false,
        foreign_key: { to_table: :accounts, name: :transactions_to_account_fk },
        comment: "The account where the transaction is going to."
      )
      t.belongs_to(
        :from_parent,
        null: true,
        foreign_key: { to_table: :accounts, name: :transactions_from_parent_account_fk },
        comment: "The parent account of the account where the transaction is coming from. This is used for performance "\
          "reasons when eager loading transactions."
      )
      t.belongs_to(
        :to_parent,
        null: true,
        foreign_key: { to_table: :accounts, name: :transactions_to_parent_account_fk },
        comment: "The parent account of the account where the transaction is going to. This is used for performance "\
          "reasons when eager loading transactions."
      )
      t.decimal(
        :from_amount,
        null: false,
        scale: 2,
        precision: 16,
        comment: "The amount debited from the source/from account. These values are also used to store the exchange rate"\
          "of the transaction at the executed_at date."
      )
      t.decimal(
        :to_amount,
        null: false,
        scale: 2,
        precision: 16,
        comment: "The amount credited to the destination/to account. These values are also used to store the exchange "\
          "rate of the transaction at the executed_at date."
      )
      t.string :currency, null: false
      t.date(
        :issued_at,
        null: false,
        index: { name: :transactions_issued_at_idx },
        comment: "Date when the transaction was issued. Meaning when the transaction was debited from the source/from "\
          "account."
      )
      t.date(
        :executed_at,
        null: true,
        index: { name: :transactions_executed_at_idx },
        comment: "Date when the transaction was executed. Meaning when the transaction was credited to the destination/to "\
          "account."
      )
      t.datetime(
        :deleted_at,
        null: true,
        index: { name: :transactions_deleted_at_index },
        comment: "A soft deletion mechanism for transactions using a timestamp. To quickly handle deletion on the UI, "\
          "while allowing the system to destroy asynchronously the transaction and its resources."
      )

      t.timestamps
    end
  end
end
