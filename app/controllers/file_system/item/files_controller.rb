# frozen_string_literal: true

class FileSystem::Item::FilesController < ApplicationController
  before_action :set_file, only: [ :show, :destroy, :attachment, :download ]
  before_action :set_active_storage_url_options, only: [ :upload ]

  def show
  end

  def create
    @file = FileSystem::Item::File.create_new_entry_or_version(**upload_file_params)

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
    params.permit(:parentable_id, :parentable_type).to_h.with_indifferent_access.merge(
      version: Time.current.to_fs(:number),
      file: params.require(:signed_id)
    )
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
