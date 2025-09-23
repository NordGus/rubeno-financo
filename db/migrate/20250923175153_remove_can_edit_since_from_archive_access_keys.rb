class RemoveCanEditSinceFromArchiveAccessKeys < ActiveRecord::Migration[8.1]
  def change
    remove_index :archive_access_keys, column: :can_edit_since, name: :archive_access_key_can_edit_since_idx
    remove_column :archive_access_keys, :can_edit_since, :datetime
  end
end
