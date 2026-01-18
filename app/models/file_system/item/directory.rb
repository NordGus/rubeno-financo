# frozen_string_literal: true

##
# FileSystem::Item::Directory represents a directory in the file system file tree. This is a way to containerize files
# in the file system structure that allow the user group files and subdirectories together in a single place, to build
# their own organization system.
class FileSystem::Item::Directory < FileSystem::Item
  has_many :directories, class_name: "FileSystem::Item::Directory", as: :parentable, dependent: :destroy
  has_many :files, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  default_scope { includes(:directories, files: :versions) }

  # FileSystem::Item::Directory can only be a child of a Mount or another Directory.
  validates :parentable_type, inclusion: { in: [ FileSystem::Item::Mount.name, FileSystem::Item::Directory.name ] }
end
