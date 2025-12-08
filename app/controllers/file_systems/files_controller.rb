# frozen_string_literal: true

class FileSystems::FilesController < ApplicationController
  before_action :set_file, only: [ :attachment ]

  def attachment
    send_data @file.file.download,
              filename: [ @file.version, @file.name ].join("_"),
              type: @file.file.content_type || "application/octet-stream",
              disposition: "inline"
  end

  def download
    send_file @file.file.download,
              filename: [ @file.version, @file.name ].join("_"),
              type: @file.file.content_type || "application/octet-stream",
              disposition: "attachment"
  end

  private

    def set_file
      @file = Current.archive.file_system_files.includes(:versions).find(params.expect(:id))
    end
end
