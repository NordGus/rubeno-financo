# frozen_string_literal: true

class FileSystem::Item::FilesController < ApplicationController
  before_action :set_file, only: [ :show, :destroy, :attachment, :download ]
  before_action :set_active_storage_url_options, only: [ :upload ]

  def show
  end

  def create
    @file = FileSystem::Item::File.current.new(upload_file_params)
    @file.name = @file.file.filename.to_s

    previous_version = FileSystem::Item::File.includes(:versions).find_by(parentable: @file.parentable, name: @file.name)

    @file.transaction do
      # if there's a file with the same name in the parentable we need to make the name unique, so we version it
      @file.name = [ @file.version, @file.name ].join("_") if previous_version

      @file.save!

      # if there's a previous version of the file, we need to make it the latest version by changing the previous
      # version subtree, the versions subtree of the new file and then rename it back to the duplicated name.
      if previous_version
        # Because the file name is already versioned, we just need to update their parent
        previous_version.versions.each { |version| version.update!(parentable: @file) }
        # Because the previous version is not versioned, we need to update its name and parent
        previous_version.update!(name: [ previous_version.version, previous_version.name ].join("_"), parentable: @file)
        # Finally, we rename the file to its original name
        @file.update!(name: @file.file.filename.to_s)
      end

      @file.reload
    rescue StandardError => _e
      raise ActiveRecord::Rollback
    end

    if @file.persisted?
      @file.parentable.broadcast_update_to(
        "contents",
        target: @file.parentable,
        partial: "file_system/item/file_system",
        locals: { item: @file.parentable }
      )

      head :created
    else
      head :unprocessable_entity, error: @file.errors.full_messages.join(", ")
    end
  end

  def upload
    blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args.merge(service_name: :file_system))

    json = direct_upload_json(blob)

    # TODO: Implement a notifications channel and partial to communicate the upload progress to the client using
    #   ActionCable.

    render json:
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

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  def set_file
    @file = FileSystem::Item::File.current.in_system.find(params.expect(:id))
  end

  def upload_file_params
    params[:version] = Time.current.to_fs(:number)
    params[:file] = params.require(:signed_id)

    params.permit(:file, :parentable_id, :parentable_type, :version)
  end

  def blob_args
    params.expect(blob: [ :filename, :byte_size, :checksum, :content_type, metadata: {} ]).to_h.symbolize_keys
  end

  def direct_upload_json(blob)
    blob.as_json(root: false, methods: :signed_id).merge(direct_upload: {
      url: blob.service_url_for_direct_upload,
      headers: blob.service_headers_for_direct_upload
    })
  end
end
