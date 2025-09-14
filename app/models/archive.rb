class Archive < ApplicationRecord
  belongs_to :owner, class_name: "Character", inverse_of: :archives
  has_many :sessions, inverse_of: :archive, dependent: :nullify, foreign_key: :archive_id

  scope :accessible_by, ->(character_id) { where(character_id:) }
  scope :editable_by, ->(character_id) { where(character_id:) }
  scope :configurable_by, ->(character_id) { where(character_id:) }

  validates :name, presence: true, length: { maximum: 256 }
  validates :description, length: { maximum: 1_000 }
end
