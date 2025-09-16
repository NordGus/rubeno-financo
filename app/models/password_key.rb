class PasswordKey < ApplicationRecord
  has_secure_password

  default_scope -> { includes(:character) }

  has_one :padlock, as: :keyable, dependent: :destroy
  has_one :character, through: :padlock
end
