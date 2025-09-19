class Session::UpdateLastSignedInAtJob < ApplicationJob
  queue_as :default

  def perform(session)
    session.update(last_signed_in_at: Time.zone.now)
  end
end
