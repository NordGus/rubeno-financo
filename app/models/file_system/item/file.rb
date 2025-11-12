# frozen_string_literal: true

class FileSystem::Item::File < FileSystem::Item
  has_one_attached :file, service: :local, strict_loading: true

  has_many :versions, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  default_scope { includes(:versions) }

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
