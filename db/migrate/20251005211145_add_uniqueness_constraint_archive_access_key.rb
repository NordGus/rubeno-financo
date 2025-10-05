class AddUniquenessConstraintArchiveAccessKey < ActiveRecord::Migration[8.1]
  def change
    add_index :archive_access_keys, [ :archive_id, :owner_id ], unique: true, name: :single_owner_key_per_archive_constraint_idx
  end
end
