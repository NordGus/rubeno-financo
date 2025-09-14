class Padlock < ApplicationRecord
  belongs_to :character
  belongs_to :keyable, polymorphic: true, dependent: :destroy
end
