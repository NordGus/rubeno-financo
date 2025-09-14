class Character < ApplicationRecord
  includes EmailValidator

  validates :email_address, uniqueness: true, presence: true, email: true
  validates :tag, uniqueness: true, presence: true, length: { maximum: 256 }

  normalizes :email_address, with: ->(email) { email.strip.downcase }
  normalizes :tag, with: ->(tag) { tag.strip.gsub(/\s+/, "") }

  # cleanup associations
  has_many :padlocks, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :archives, dependent: :destroy, foreign_key: :owner_id
  has_many :archive_access_keys, class_name: "Archive::AccessKey", dependent: :destroy, foreign_key: :owner_id
end
