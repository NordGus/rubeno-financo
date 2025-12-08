# frozen_string_literal: true

class FileSystemsController < AppController
  before_action :set_file_system, only: [ :show ]

  def show
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_file_system
    @file_system = Current.archive.file_systems.includes(:directories, :files, :mountable).find(params.fetch(:file_system_id, params.expect(:id)))
  end
end
