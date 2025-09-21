class Session < ApplicationRecord
  MAX_LIFESPAN = 6.hours

  has_secure_token :token, length: 64

  belongs_to :character, inverse_of: :sessions
  belongs_to :archive, inverse_of: :sessions, optional: true, foreign_key: :archive_id
end
