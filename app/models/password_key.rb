class PasswordKey < ApplicationRecord
  has_secure_password

  validates :key_version, presence: true

  before_validation ->(record) { record.key_version = SecureRandom.uuid_v7 }, if: :new_record?

  has_one :padlock, as: :keyable, dependent: :destroy
  has_one :character, through: :padlock

  def replace_key!
    update(key_version: SecureRandom.uuid_v7)
  end
end
