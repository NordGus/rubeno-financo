class AddDeletedAtColumnToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column(
      :accounts,
      :deleted_at,
      :datetime,
      comment: "A soft deletion mechanism for accounts using a timestamp. To quickly handle deletion on the UI, "\
        "while allowing the system to destroy asynchronously the account and its resources."
    )

    add_index(
      :accounts,
      :deleted_at,
      name: :accounts_deleted_at_idx,
      if_not_exists: true,
      comment: "Index to speed up queries on deleted or non-deleted accounts."
    )
  end
end
