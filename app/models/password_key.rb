class PasswordKey < ApplicationRecord
  has_secure_password

  has_one :padlock, as: :keyable, dependent: :destroy
end
