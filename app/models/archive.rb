class Archive < ApplicationRecord
  belongs_to :owner, class_name: "Character", inverse_of: :archives
  has_many :sessions, inverse_of: :archive, dependent: :nullify, foreign_key: :archive_id
end
