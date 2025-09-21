class Archive < ApplicationRecord
  belongs_to :owner, class_name: "Character", foreign_key: :owner_id
  has_many :sessions, dependent: :nullify, foreign_key: :archive_id
  has_many :access_keys, class_name: "Archive::AccessKey", dependent: :destroy

  default_scope { includes(:access_keys, :owner) }

  scope :owned_by, ->(character_id) { where(owner_id: character_id) }
  scope :accessible_by, ->(character_id) do
    owned_by(character_id)
      .or(
          where(access_keys: { owner_id: character_id })
            .where('"access_keys"."expires_at" >= ?', Time.zone.now)
            .or(
              where(access_keys: { owner_id: character_id })
                .where(access_keys: { expires_at: nil })
            )
      )
  end
  scope :editable_by, ->(character_id) do
    owned_by(character_id)
      .accessible_by(character_id)
      .where.not(access_keys: { can_edit_since: nil })
  end
  scope :configurable_by, ->(character_id) { owned_by(character_id) }

  validates :name, presence: true, length: { maximum: 256 }
  validates :description, length: { maximum: 1_000 }

  def can_edit?(character_id)
    # TODO: This is super inefficient, I have to find a more performant way that relies less on hammering the database.
    access_keys.active.with_editable_access.owned_by(character_id).exists?
  end

  def can_configure?(character_id)
    owner_id == character_id
  end

  def can_access?(character_id)
    # TODO: This is super inefficient, I have to find a more performant way that relies less on hammering the database.
    access_keys.active.owned_by(character_id).exists?
  end

  def is_accessible_by(character_id)
    can_configure?(character_id) || can_edit?(character_id) || can_access?(character_id)
  end
end
