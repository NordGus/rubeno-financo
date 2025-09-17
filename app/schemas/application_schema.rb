# frozen_string_literal: true

class ApplicationSchema
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::SecurePassword
  include ActiveModel::Callbacks

  def new_record?
    !id.present?
  end
end
