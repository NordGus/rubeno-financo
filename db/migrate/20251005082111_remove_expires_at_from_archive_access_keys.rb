# frozen_string_literal: true

class RemoveExpiresAtFromArchiveAccessKeys < ActiveRecord::Migration[8.1]
  def change
    remove_index :archive_access_keys, column: :expires_at, name: :archive_access_key_expires_at_idx
    remove_column :archive_access_keys, :expires_at, :datetime
  end
end
