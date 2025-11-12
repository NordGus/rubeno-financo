# frozen_string_literal: true

class CreateFileSystems < ActiveRecord::Migration[8.1]
  def change
    create_table :file_systems do |t|
      t.belongs_to(
        :mountable,
        polymorphic: true,
        null: false,
        index: {
          name: :file_systems_mountable_index,
          unique: true,
          comment: "A uniqueness constraint for file system's mounting points, ensuring a single file system is " \
            "mounted to the mountable record only."
        },
        comment: "Is a polymorphic relation to indicate the record to which the file system is mounted to. This is used " \
          "to make the file system feature flexible enough to be related to any model so the user can store files " \
          "related to such model record an structure it any way the want to"
      )
      t.belongs_to(
        :archive,
        null: false,
        foreign_key: { to_table: :archives, name: :file_system_archive_fk },
        comment: "The archive that the file system belongs to. This column is used for a quick authorization check " \
          "when a user tries to access the file system or any of its items."
      )
      t.datetime(
        :deleted_at,
        index: { name: :file_system_deleted_at_index },
        comment: "A soft deletion mechanism for file system using a timestamp. To quickly handle deletion on the "\
          "UI, while allowing the system to destroy asynchronously the record and its children."
      )

      t.timestamps
    end
  end
end
