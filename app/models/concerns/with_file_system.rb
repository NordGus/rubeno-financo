# frozen_string_literal: true

##
# WithFileSystem is a concern to indicate that a model has a file system mounted to it.
module WithFileSystem
  extend ActiveSupport::Concern

  included do
    has_one :file_system, class_name: "FileSystem::Item::Mount", as: :parentable, dependent: :destroy
  end
end
