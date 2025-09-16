# frozen_string_literal: true

# FirstRunForm is the data representation and validator for
class FirstRunForm < Character::CreateForm
  def self.model_name
    ActiveModel::Name.new(self, nil, "FirstRun")
  end
end
