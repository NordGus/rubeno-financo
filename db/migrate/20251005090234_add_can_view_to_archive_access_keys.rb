class AddCanViewToArchiveAccessKeys < ActiveRecord::Migration[8.1]
  def change
    add_column :archive_access_keys, :can_view, :boolean, null: false, default: false

    add_index :archive_access_keys, :can_view, name: :archive_access_key_can_view_idx
  end
end
