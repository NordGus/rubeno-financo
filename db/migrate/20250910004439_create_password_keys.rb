class CreatePasswordKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :password_keys do |t|
      t.string :password_digest
      t.datetime :last_sign_in
      t.datetime :blocked_at
      t.integer :attempted_access_count
      t.string :key_version, null: false

      t.timestamps
    end

    add_index :password_keys, :key_version, name: :password_keys_key_version_index
  end
end
