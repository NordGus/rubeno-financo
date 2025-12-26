# frozen_string_literal: true

##
# FileSystem::Item represents a mount, file, or directory in the file system file tree. This is the base class for all
# items because the file system structure uses STI (Single Table Inheritance) to implement its elements. Inspired by
# Unix's file system data structure the [inode](https://en.wikipedia.org/wiki/Inode). This allows financo to build a
# powerful file system abstraction over Active Storage that operates like the file system on any operating system, while
# having a desktop-inspired UX, like Apple's Finder (macOS) or Files (iOS, iPadOS), Microsoft's File Explorer (Windows),
# Gnome's Files (Linux) or KDE Plasma's Dolphin (Linux).
#
# Additionally, it also allows financo to implement a really naive versioning system for files that share the same name
# and parent, like Google Drive's UX does. However, their versioning system is most likely more complex than what
# financo needs, but it is a good example of how it can be implemented for UX purposes. This will increase the storage
# usage of financo, but I think it is a necessary compromise to ensure that the characters don't lose data by accident,
# outside catastrophic hardware or bedrock software failure.
#
# Why use this instead of hard defining a hard attachment structure for the application?
#
# I'm not smart enough to enforce a universal structure for other people's finance documentation system being build
# around. My strong opinion is that everyone who wants to use a personal finances application to take control of their
# finances wants to:
#
#   1. Have a highly opinionated structure to register and track their income and expenses and have an all-encompassing
#      vision of their current financial health. financo provides this with its Account->Transaction->Account graph
#      model used on each archive's ledger.
#
#   2. Have a way to store documentation related to their different accounts, so they have a centralized digital archive
#      of such documentation. Which financo's file system feature gives them.
#
#   3. Structure how they store and navigate their stored files for their own systems of order and classification. Most
#      people know how to use a file explorer system on a digital device, because this kind of UX has been standardized
#      by mainstream OS Graphical User Interface for at least 30-years thanks to the explosion of Windows95. Again, this
#      file system feature provides them with such a possibility thanks to the file tree structure built on top of this
#      base class.
#
# @note This class is not meant to be used directly, but instead through its subclasses.
class FileSystem::Item < ApplicationRecord
  belongs_to :parentable, polymorphic: true
  belongs_to :archive

  # All file system items must have a unique name, except for files, which can have the same name as other files as long
  # as they are in different directories and their parent is another file, which makes them different versions of the
  # same file. And Mounts because the names for different
  validates :name,
            presence: true,
            uniqueness: { scope: :parentable, condition: -> { where.not(parentable_type: [ FileSystem::Item::File.name, FileSystem::Item::Mount.name ]) } }
  # All file system items must have a version. This will be used for caching.
  validates :version,
            presence: true
  # We need to make sure the item is not its own parent to prevent loops on the file system tree.
  validates :parentable_id, comparison: { other_than: :id }, if: ->(record) { record.type == record.parentable_type }

  # current is a scope that only returns items that are on the character currently selected archive. This is used to
  # display items on the UI in the currently selected archive.
  scope :current, -> { where(archive: Current.archive) }
  # in_system is a scope that only returns items that are not softly deleted. This is used to display non-deleted items
  # on the UI.
  scope :in_system, -> { where(deleted_at: nil) }

  has_many :children, class_name: "FileSystem::Item", as: :parentable, dependent: :destroy

  normalizes :name, with: ->(name) { name&.strip }
  normalizes :version, with: ->(version) { version || Time.current.to_fs(:number) }, apply_to_nil: true

  # returns the file_system_route for this directory, starting with the file system root and ending with this directory.
  # @note This method is memoized because its build by an N+1 query, and I haven't found a way to avoid it. But I do not
  #   expect this N+1 query to be a problem in practice because the debt of the file tree in a file system would not be
  #   very deep.
  def file_system_route
    @file_system_route ||= begin
      current = self
      breadcrumbs = []

      loop do
        breadcrumbs.prepend(current)
        break unless current.respond_to?(:parentable)
        current = current.parentable
      end

      breadcrumbs
    end
  end

  def soft_destroy
    timestamp = Time.current
    success = nil

    transaction do
      children.update_all(deleted_at: timestamp)
      success = update!(deleted_at: timestamp)
      Cleanup::DestroySoftDeletedRecordJob.perform_later(self)
    end

    success
  end

  def is_a_file_version?
    is_a_file? && parentable_type == FileSystem::Item::File.name
  end

  def is_a_file?
    type == FileSystem::Item::File.name
  end

  def is_a_directory?
    type == FileSystem::Item::Directory.name
  end
end
