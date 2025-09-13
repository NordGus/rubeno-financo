class CreatePasswordKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :password_keys do |t|
      t.string :password_digest
      t.datetime :last_sign_in_at
      t.datetime :blocked_at, index: { name: :password_key_blocked_at_idx }
      t.integer :attempted_access_count

      t.timestamps
    end
  end
end
