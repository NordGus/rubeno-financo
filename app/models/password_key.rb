class PasswordKey < ApplicationRecord
  has_secure_password

  default_scope -> { includes(:character) }

  has_one :padlock, as: :keyable, dependent: :destroy
  has_one :character, through: :padlock

  def self.authenticate(username: nil, password: nil)
    authenticate_by(character: { email_address: username }, password:) || authenticate_by(character: { tag: username }, password:)
  end
end
