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

  has_many :children, class_name: "FileSystem::Item", as: :parentable, dependent: :destroy

  normalize :name, with: ->(name) { name&.strip }
  normalize :version, with: ->(version) { version || Time.current.to_fs(:number) }
end
