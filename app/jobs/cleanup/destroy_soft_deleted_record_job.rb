# frozen_string_literal: true

##
# DestroySoftDeletedRecordJob is a job to destroy any soft deleted record.
class Cleanup::DestroySoftDeletedRecordJob < ApplicationJob
  queue_as :low_priority

  def perform(record)
    record.destroy!
  end
end
