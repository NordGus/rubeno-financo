class RemoveLastSignInAtFromSessions < ActiveRecord::Migration[8.1]
  def change
    remove_index :sessions, column: :last_signed_in_at, name: :sessions_last_signed_in_at_idx
    remove_column :sessions, :last_sign_in_at, :datetime, null: false
  end
end
