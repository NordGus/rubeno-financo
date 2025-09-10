class Character < ApplicationRecord
  validates :tag, uniqueness: true, presence: true, length: { minimum: 7, maximum: 256 }
  validates :padlock_version, presence: true

  before_validation ->(character) { character.tag = character.tag.gsub(/\s+/, "") }
  before_validation ->(character) { character.padlock_version = SecureRandom.uuid_v7 }, if: :new_record?

  has_many :padlocks, dependent: :destroy

  def replace_padlock!
    update(padlock_version: SecureRandom.uuid_v7)
  end
end
