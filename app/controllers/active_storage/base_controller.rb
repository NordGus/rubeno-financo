# frozen_string_literal: true

class ActiveStorage::BaseController < ActionController::Base
  include Authentication
  include Tenanted
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :exception

  self.etag_with_template_digest = false
end
