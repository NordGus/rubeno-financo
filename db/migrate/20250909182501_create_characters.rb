class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :tag, null: false
      t.string :padlock_version, null: false

      t.timestamps
    end

    add_index :characters, :tag, unique: true, name: :characters_tags_index
    add_index :characters, :padlock_version, name: :characters_padlock_version_index
  end
end
