class Padlock < ApplicationRecord
  belongs_to :character
  belongs_to :keyable, polymorphic: true
end
