class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :type, index: { name: :accounts_type_idx, null: false }
      t.string :name, null: false
      t.text :description
      t.string :currency, null: false
      t.belongs_to :parent, null: true, foreign_key: true
      t.belongs_to :archive, null: false, foreign_key: true

      t.timestamps
    end
  end
end
