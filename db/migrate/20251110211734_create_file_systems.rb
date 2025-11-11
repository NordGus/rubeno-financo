# frozen_string_literal: true

class CreateFileSystems < ActiveRecord::Migration[8.1]
  def change
    create_table :file_systems do |t|
      t.belongs_to(
        :mountable,
        polymorphic: true,
        null: false,
        type: :foreign_key_type,
        index: { name: :file_systems_mountable_index },
        comment: "Is a polymorphic relation to indicate the record to which the file system is mounted to. This is used " \
          "to make the file system feature flexible enough to be related to any model so the user can store files " \
          "related to such model record an structure it any way the want to"
      )

      t.timestamps
    end
  end
end
