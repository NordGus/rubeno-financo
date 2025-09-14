class CreateArchives < ActiveRecord::Migration[8.0]
  def change
    create_table :archives do |t|
      t.belongs_to :owner, null: false, foreign_key: { to_table: :characters, name: :archives_owner_fk }
      t.string :name, null: false, index: { name: :archives_name_idx }
      t.text :description

      t.timestamps
    end
  end
end
