class Character < ApplicationRecord
  before_save do |character|
    character.tag = character.tag.gsub(/\s+/, "")
  end

  before_create do |character|
    character.padlock_version = SecureRandom.uuid_v7
  end

  validates :tag, uniqueness: true, presence: true, length: { minimum: 7, maximum: 256 }
  validates :padlock_version, uniqueness: true, presence: true

  def replace_padlock!
    update(padlock_version: SecureRandom.uuid_v7)
  end
end
