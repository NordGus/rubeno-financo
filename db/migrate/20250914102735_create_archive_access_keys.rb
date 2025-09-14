class CreateArchiveAccessKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :archive_access_keys do |t|
      t.belongs_to :owner, null: false, foreign_key: { to_table: :characters, name: :archive_access_key_characters_fk }
      t.belongs_to :archive, null: false, foreign_key: { to_table: :archives, name: :archive_access_keys_archives_fk }
      t.datetime :expires_at, index: { name: :archive_access_key_expires_at_idx }
      t.datetime :can_edit_since, index: { name: :archive_access_key_can_edit_since_idx }

      t.timestamps
    end
  end
end
