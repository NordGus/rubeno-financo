class RemoveBlockedAtFromPasswordKeys < ActiveRecord::Migration[8.0]
  def change
    remove_index :password_keys, column: :blocked_at, name: :password_key_blocked_at_idx
    remove_column :password_keys, :blocked_at, :datetime, if_exists: true
  end
end
