class CreatePadlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :padlocks do |t|
      t.belongs_to :character, null: false, foreign_key: { to_table: :characters, name: :padlocks_characters_fk }
      t.belongs_to :keyable, polymorphic: true

      t.timestamps
    end

    add_index :padlocks, [ :character_id, :keyable_id, :keyable_type ], unique: true, name: :padlocks_character_keyable_uniqueness_idx
  end
end
