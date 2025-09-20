class ApplicationController < ActionController::Base
  include Authentication, Tenanted
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def welcome
    @accessible_archives = Archive.accessible_by(Current.character.id)
  end
end
