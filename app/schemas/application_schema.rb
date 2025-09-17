# frozen_string_literal: true

class ApplicationSchema
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::SecurePassword
  include ActiveModel::Callbacks

  def new_record?
    !id&.present?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.gsub(/Schema$/, ""))
  end
end
