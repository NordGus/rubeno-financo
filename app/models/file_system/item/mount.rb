# frozen_string_literal: true

##
# FileSystem::Item::Mount represents the mounting point for a pseudo file system abstraction over Active Storage so
# characters can store file related to other financo models parentable and define their own structure.
class FileSystem::Item::Mount < FileSystem::Item
  has_many :directories, class_name: "FileSystem::Item::Directory", as: :parentable, dependent: :destroy
  has_many :files, class_name: "FileSystem::Item::File", as: :parentable, dependent: :destroy

  # before validating the record, we need to set the name to that of its parentable.
  before_validation { |record|record.name = record.parentable&.name unless record.name == record.parentable&.name }

  validates :parentable_type,
            exclusion: {
              in: [
                # All mount points must be mounted to a non-file system record. Because it is used to connect the file
                # system feature to other financo models.
                FileSystem::Item::Mount.name,
                FileSystem::Item::File.name,
                FileSystem::Item::Directory.name,
                FileSystem::Item.name,
                # It cannot be mounted to a system account record. Because these accounts are used for financo's systems
                # to operate and no character has access to them.
                Account::System::History.name
              ]
            }

  validates :parentable_id,
            # It can only be the mounting point for a file system per mountable record.
            uniqueness: { scope: [ :parentable_type, :archive ] }
end
