# frozen_string_literal: true

class FileSystem::Item::File < FileSystem::Item
  has_one_attached :file, service: :file_system

  has_many :versions, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  default_scope { includes(:versions) }

  # FileSystem::Item::File can only be a child of a FileSystem, a Directory or a File. When the File is a child of
  # another File, it is considered a version of the parent File.
  validates :parentable_type, inclusion: { in: [ FileSystem.name, FileSystem::Item::Directory.name, FileSystem::Item::File.name ] }

  def soft_destroy
    timestamp = Time.current
    success = nil

    transaction do
      versions.update_all(deleted_at: timestamp)
      success = update!(deleted_at: timestamp)
      Cleanup::DestroySoftDeletedRecordJob.perform_later(self)
    end

    success
  end
end
