# frozen_string_literal: true

class FileSystems::FilesController < FileSystemsController
  before_action :set_file_system
  before_action :set_latest_file, only: [ :show, :destroy ]
  before_action :set_file, only: [ :attachment, :download ]

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
    # set_latest_file and set_file are mutually exclusive. set_latest_file is used for actions related to the UI, while
    # set_file is used for extracting any file version for download or attachment in the application.

    def set_latest_file
      @file = Current.archive.file_system_files.includes(:versions).in_system.latest_versions.find(params.expect(:id))
    end

    def set_file
      @file = Current.archive.file_system_files.includes(:versions).in_system.find(params.expect(:id))
    end
end
