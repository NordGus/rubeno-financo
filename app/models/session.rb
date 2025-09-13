class Session < ApplicationRecord
  belongs_to :character, inverse_of: :sessions
end
