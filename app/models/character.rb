class Character < ApplicationRecord
  before_save do |character|
    character.tag = character.tag.gsub(/\s+/, "")
  end

  before_create do |character|
    character.padlock_version = SecureRandom.uuid_v7
  end

  validates :tag, uniqueness: true, presence: true, length: { minimum: 7, maximum: 256 }
  validates :padlock_version, uniqueness: true, presence: true

  has_many :padlocks
  has_many :keyables, through: :padlocks, dependent: :destroy

  def replace_padlock!
    update(padlock_version: SecureRandom.uuid_v7)
  end
end
