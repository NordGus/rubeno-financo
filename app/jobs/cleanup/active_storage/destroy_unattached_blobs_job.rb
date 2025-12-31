# frozen_string_literal: true

##
# DestroyUnattachedBlobsJob is a job to destroy any unattached blobs that were left orphan in the system for more than
# 24 hours so the disk space can be reclaimed.
class Cleanup::ActiveStorage::DestroyUnattachedBlobsJob < ApplicationJob
  queue_as :background

  def perform
    ActiveStorage::Blob.unattached.where(created_at: ..1.day.ago).select(:id).find_each(&:purge_later)
  end
end
