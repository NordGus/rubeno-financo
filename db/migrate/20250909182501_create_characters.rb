class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :email_address, null: false
      t.string :tag, null: false

      t.timestamps
    end

    add_index :characters, :email_address, unique: true, name: :characters_email_address_uniqueness_idx
    add_index :characters, :tag, unique: true, name: :characters_tag_uniqueness_idx
  end
end
