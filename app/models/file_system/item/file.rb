# frozen_string_literal: true

class FileSystem::Item::File < FileSystem::Item
  has_one_attached :file, service: :file_system

  has_many :versions, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  scope :latest_versions, -> { where.not(parentable_type: FileSystem::Item::File.name) }

  # FileSystem::Item::File can only be a child of a Mount, a Directory or a File. When the File is a child of another
  # File, it is considered a version of the parent File.
  validates :parentable_type, inclusion: { in: [ FileSystem::Item::Mount.name, FileSystem::Item::Directory.name, FileSystem::Item::File.name ] }

  class << self
    def create_new_entry_or_version(parentable_type:, parentable_id:, file:, version:)
      instance = current.new(parentable_type:, parentable_id:, file:, version:)
      instance.name = instance.file.filename.to_s

      previous_version = includes(:versions).latest_versions.find_by(parentable: instance.parentable, name: instance.filename.to_s)

      # if there's no previous version of the file, we can just create the new file and
      unless previous_version.present?
        instance.save

        return instance.reload
      end

      transaction do
        original_name = instance.name

        # We need to make the name unique, so we just version it
        instance.name = [ instance.version, instance.name ].join("_")

        instance.save!

        # if there's a previous version of the file, we need to make it the latest version by changing the previous
        # version subtree, the versions subtree of the new file and then rename it back to the duplicated name.

        # Because the file name is already versioned, we just need to update their parent
        previous_version.versions.each { |version| version.update!(parentable: instance) }
        # Because the previous version is not versioned, we need to update its name and parent
        previous_version.update!(name: [ previous_version.version, previous_version.name ].join("_"), parentable: instance)
        # Finally, we rename the file to its original name
        instance.update!(name: original_name)

        instance.reload
      rescue StandardError => e
        Rails.logger.debug e

        raise ActiveRecord::Rollback
      end
    end
  end
end
