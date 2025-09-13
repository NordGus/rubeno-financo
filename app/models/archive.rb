class Archive < ApplicationRecord
  belongs_to :owner, class_name: "Character", inverse_of: :archives
end
