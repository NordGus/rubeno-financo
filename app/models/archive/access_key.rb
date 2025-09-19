class Archive::AccessKey < ApplicationRecord
  belongs_to :owner, class_name: "Character", foreign_key: :owner_id
  belongs_to :archive

  scope :owned_by, ->(character_id) { where(owner_id: character_id) }
  scope :active, -> { where("expires_at >= ?", Time.zone.now).or(where(expires_at: nil)) }
  scope :with_editable_access, -> { where.not(can_edit_since: nil) }
end
