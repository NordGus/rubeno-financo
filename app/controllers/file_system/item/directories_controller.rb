# frozen_string_literal: true

class FileSystem::Item::DirectoriesController < ApplicationController
  before_action :set_directory, only: [ :show ]

  def show
    respond_to do |format|
      format.html
    end
  end

  private
    def set_directory
      @directory = FileSystem::Item::Directory.current.in_system.find(params.expect(:id))
    end
end
