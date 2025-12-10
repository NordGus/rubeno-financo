# frozen_string_literal: true

class FileSystems::DirectoriesController < FileSystemsController
  before_action :set_file_system
  before_action :set_directory, only: [ :show ]

  def show
    respond_to do |format|
      format.html
    end
  end

  private
    def set_directory
      @directory = Current.archive.file_system_directories.includes(:directories, :files).find(params.expect(:id))
    end
end
