class Character < ApplicationRecord
  includes EmailValidator

  validates :email_address, uniqueness: true, presence: true, email: true
  validates :tag, uniqueness: true, presence: true, length: { maximum: 256 }

  normalizes :email_address, with: ->(email) { email.strip.downcase }
  normalizes :tag, with: ->(tag) { tag.strip.gsub(/\s+/, "") }

  has_many :padlocks, inverse_of: :character, dependent: :destroy
  has_many :sessions, inverse_of: :character, dependent: :destroy
end
