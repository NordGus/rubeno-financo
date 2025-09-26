class AddTokenToSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sessions, :token, :string, null: false
    add_index :sessions, :token, unique: true, name: :sessions_token_uniqueness_idx
  end
end
