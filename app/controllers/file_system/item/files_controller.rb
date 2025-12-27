# frozen_string_literal: true

class FileSystem::Item::FilesController < ApplicationController
  before_action :set_file, only: [ :show, :destroy, :attachment, :download ]

  def show
  end

  def destroy
    if @file.soft_destroy
      @file.broadcast_remove_to [ @file_system, "contents" ], targets: @file

      head :no_content
    else
      head :unprocessable_entity, error: @file.errors.full_messages.join(", ")
    end
  end

  def attachment
    send_data @file.file.download,
              filename: [ @file.version, @file.name ].join("_"),
              type: @file.file.content_type || "application/octet-stream",
              disposition: "inline"
  end

  def download
    send_data @file.file.download,
              filename: [ @file.version, @file.name ].join("_"),
              type: @file.file.content_type || "application/octet-stream",
              disposition: "attachment"
  end

  private
    def set_file
      @file = FileSystem::Item::File.current.in_system.find(params.expect(:id))
    end
end
