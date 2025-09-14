class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def welcome
    @accessible_archives = Archive.includes(:owner).accessible_by(Current.character.id)
  end
end
