class Session < ApplicationRecord
  belongs_to :character, inverse_of: :sessions
  belongs_to :archive, inverse_of: :sessions, optional: true, foreign_key: :archive_id
end
