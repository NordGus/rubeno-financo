class Archive::AccessKey::CreateMissingKeysForCharacterJob < ApplicationJob
  queue_as :default

  retry_on ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotSaved

  def perform(character)
    character_id = character.id

    # NOTE: This is not a performant way to create the missing access keys, but it strongly enforces the validations.
    #   Also, financo is designed to work on a self-hosted deployment for their users. So the amount of users and/or
    #   probably won't go pass the thousands in the current vision for the application. Also, the concurrent traffic
    #   into the instance will probably so low, that the probability of synchronization errors produced by this approach
    #   will be also low.
    Archive.not.owned_by(character_id).not.accessible_by(character_id).find_each do |archive|
      archive.access_keys.create_with(can_view: false, can_edit: false).find_or_create_by!(character_id: character_id)
    end
  end
end
