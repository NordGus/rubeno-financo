# frozen_string_literal: true

##
# FileSystem::Item represents a file or directory in the file system file tree. This is the base class for all items
# because the file system structure uses STI (Single Table Inheritance) to implement directories and files.
class FileSystem::Item < ApplicationRecord
  belongs_to :parentable, polymorphic: true
  belongs_to :archive

  validates :name,
            presence: true,
            uniqueness: { scope: :parentable, condition: -> { where.not(parentable_type: FileSystem::Item::File.name) } }
  validates :version, presence: true
  # We need to make sure the item is not its own parent.
  validates :parentable_id,
            comparison: { other_than: :id },
            if: ->(record) { record.type == record.parentable_type }

  scope :in_system, -> { where(deleted_at: nil) }

  has_many :children, class_name: "FileSystem::Item", as: :parentable, dependent: :destroy

  normalizes :name, with: ->(name) { name&.strip }
  normalizes :version, with: ->(version) { version || Time.current.to_fs(:number) }

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
