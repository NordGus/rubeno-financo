class CreatePadlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :padlocks do |t|
      t.belongs_to :character, null: false, foreign_key: { to_table: :characters, name: :padlocks_characters_fk }
      t.belongs_to :keyable, polymorphic: true

      t.timestamps
    end
  end
end
