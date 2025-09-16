# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::SecurePassword
  include ActiveModel::Callbacks

  def new_record?
    !id.present?
  end
end
