# frozen_string_literal: true

class FirstRun
  def self.create!(form)
    Character.transaction do
      protagonist = Character.create!(email_address: form.email_address, tag: form.username)
      keyable = PasswordKey.create!(password: form.password, password_confirmation: form.password_confirmation)
      archive = Archive.create!(name: "#{protagonist.tag}'s finances", owner: protagonist)

      protagonist.padlocks.create!(keyable:)
      keyable.reload_padlock
      keyable.reload_character

      [ keyable, archive ]
    end
  end
end
