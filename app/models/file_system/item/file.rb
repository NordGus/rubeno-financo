# frozen_string_literal: true

class FileSystem::Item::File < FileSystem::Item
  has_one_attached :file, service: :file_system

  has_many :versions, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  scope :latest_versions, -> { where.not(parentable_type: FileSystem::Item::File.name) }

  # FileSystem::Item::File can only be a child of a Mount, a Directory or a File. When the File is a child of another
  # File, it is considered a version of the parent File.
  validates :parentable_type, inclusion: { in: [ FileSystem::Item::Mount.name, FileSystem::Item::Directory.name, FileSystem::Item::File.name ] }
end
