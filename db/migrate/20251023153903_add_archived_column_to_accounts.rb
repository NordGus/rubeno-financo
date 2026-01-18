class AddArchivedColumnToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column(
      :accounts,
      :archived,
      :boolean,
      if_not_exists: true,
      null: false,
      default: false,
      comment: "Indicates if the account is archived, which means it is no longer used and"\
        "should not appeared anywhere in the UI that can create new resources associated to accounts."
    )

    add_index(
      :accounts,
      :archived,
      name: :accounts_archived_idx,
      if_not_exists: true,
      comment: "Index to speed up queries on archived or non-archived accounts."
    )
  end
end
