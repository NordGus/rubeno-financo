class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :character, null: false, foreign_key: { name: :sessions_character_fk }
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
