# frozen_string_literal: true

class FileSystem::Item::MountsController < ApplicationController
  before_action :set_mount, only: [ :show ]

  def show
    respond_to do |format|
      format.html
    end
  end

  private

    def set_mount
      @mount = FileSystem::Item::Mount.current.in_system.find(params.expect(:id))
    end
end
