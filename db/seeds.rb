# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  protagonist = Character
                  .includes(:padlocks, :configurable_archives, :editable_archives, :accessible_archives)
                  .create_with(email_address: 'protagonist@example.com')
                  .find_or_create_by!(tag: 'protagonist')
  supporting_character = Character
                           .includes(:padlocks, :configurable_archives, :editable_archives, :accessible_archives)
                           .create_with(email_address: 'supporting_chracter@example.com')
                           .find_or_create_by!(tag: 'supporting-character')

  if protagonist.padlocks.none?
    protagonist.padlocks.create!(
      keyable: PasswordKey.create!(
        password: 'change me',
        password_confirmation: 'change me'
      )
    )
  end

  if supporting_character.padlocks.none?
    supporting_character.padlocks.create!(
      keyable: PasswordKey.create!(
        password: 'change me',
        password_confirmation: 'change me'
      )
    )
  end

  protagonist.archives.create_with(description: 'This is just a test').find_or_create_by!(name: 'My Personal Finances')
  protagonist.archives.find_or_create_by!(name: 'Family Finances') do |archive|
    supporting_character.archive_access_keys.create_with(can_edit_since: Time.zone.now - 1.year).find_or_create_by!(archive:)
  end
  protagonist.archives.find_or_create_by!(name: 'My Small Business Finances') do |archive|
    supporting_character.archive_access_keys.create_with(expires_at: Time.zone.now + 1.year).find_or_create_by!(archive:)
  end

  supporting_character.archives.find_or_create_by!(name: 'My Personal Finances')

  # Add additional seeds
end
