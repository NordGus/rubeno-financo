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

  # scoped associations, built over cleanup associations and used on business logic, do not add dependent configuration
  has_many :active_archive_access_keys, -> { active }, class_name: "Archive::AccessKey", foreign_key: :owner_id
  has_many :accessible_archives, ->(record) { unscope(where: :owner_id).accessible_by(record.id) }, class_name: "Archive", foreign_key: :owner_id
  has_many :editable_archives, ->(record) { unscope(where: :owner_id).editable_by(record.id) }, class_name: "Archive", foreign_key: :owner_id
  has_many :configurable_archives, class_name: "Archive", foreign_key: :owner_id
end
