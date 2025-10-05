class Archive::AccessKey < ApplicationRecord
  belongs_to :owner, class_name: "Character", foreign_key: :owner_id
  belongs_to :archive

  scope :owned_by, ->(character_id) { where(owner_id: character_id) }
  scope :active, -> { where(can_view: true).or(where(can_edit: true)) }
  scope :with_editable_access, -> { where(can_edit: true) }
end
