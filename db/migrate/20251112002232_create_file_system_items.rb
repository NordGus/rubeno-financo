class CreateFileSystemItems < ActiveRecord::Migration[8.1]
  def change
    create_table :file_system_items do |t|
      t.string(
        :type,
        null: false,
        index: { name: :file_system_items_type_index },
        comment: "The type of the file system item. This is used to determine the record's model. Used by Rails "\
          "Single Table Inheritance. It indicates if the record is a directory or a file."
      )
      t.belongs_to(
        :parentable,
        polymorphic: true,
        null: false,
        index: { name: :file_system_items_parentable_index },
        comment: "Is a polymorphic relation to indicate the record's parent node in the file tree graph. This is used " \
          "to make the file system structure more flexible and implement features like directories an their internal "\
          "subdirectories and files, while versioning uploaded files by the user."
      )
      t.belongs_to(
        :archive,
        null: false,
        foreign_key: { to_table: :archives, name: :file_system_items_archive_fk },
        comment: "The archive that the file system item belongs to. This column is used for a quick authorization " \
          "check when a user tries to access the item."
      )
      t.string :name, null: false, index: {}
      t.string(
        :version,
        null: false,
        comment: "The version of the file system item. This is used to implement versioning of uploaded files and " \
          "handling client-side cache invalidation."
      )
      t.datetime(
        :deleted_at,
        index: { name: :file_system_items_deleted_at_index },
        comment: "A soft deletion mechanism for file system items using a timestamp. To quickly handle deletion on the "\
          "UI, while allowing the system to destroy asynchronously the record and its children."
      )

      t.timestamps
    end

    add_index(
      :file_system_items,
      [ :name, :parentable_type, :parentable_id ],
      unique: true,
      where: "parentable_type != 'FileSystem::Item::File'",
      comment: "A uniqueness constraint for file system items with the same name in the same parent directory.",
      name: :file_system_items_name_uniqueness_index
    )

    add_index(
      :file_system_items,
      [ :parentable_type, :parentable_id ],
      unique: true,
      where: "type == 'FileSystem::Item::Mount'",
      comment: "A uniqueness constraint for mounts so that they can only be mounted once per parentable record.",
      name: :file_system_items_mount_uniqueness_index
    )
  end
end
