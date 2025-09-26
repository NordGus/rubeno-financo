class AddLastSignedInAtToSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sessions, :last_signed_in_at, :datetime, null: false
    add_index :sessions, :last_signed_in_at, name: :sessions_last_signed_in_at_idx
  end
end
