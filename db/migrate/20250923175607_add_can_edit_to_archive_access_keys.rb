class AddCanEditToArchiveAccessKeys < ActiveRecord::Migration[8.1]
  def change
    add_column :archive_access_keys, :can_edit, :boolean, null: false, default: false
    add_index :archive_access_keys, :can_edit, name: :archive_access_keys_can_edit_idx, if_not_exists: true
  end
end
