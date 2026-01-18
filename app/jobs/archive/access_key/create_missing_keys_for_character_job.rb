# frozen_string_literal: true

##
# CreateMissingKeysForCharacterJob is a job to create missing access keys for a given character. Usually done when
# a new character is added to financo, so it can be included into each archive permissions view.
class Archive::AccessKey::CreateMissingKeysForCharacterJob < ApplicationJob
  queue_as :high_priority

  retry_on ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotSaved

  def perform(character)
    character_id = character.id

    # NOTE: This is not a performant way to create the missing access keys, but it strongly enforces the validations.
    #   Also, financo is designed to work on a self-hosted deployment for their users. So the number of users and/or
    #   probably won't go pass the thousands in the current vision for the application. Also, the concurrent traffic
    #   into the instance will probably be so low that the probability of synchronization errors produced by this
    #   approach will be also low.
    Archive.not.owned_by(character_id).not.accessible_by(character_id).find_each do |archive|
      archive.access_keys.create_with(can_view: false, can_edit: false).find_or_create_by!(character_id:)
    end
  end
end
