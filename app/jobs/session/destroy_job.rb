# frozen_string_literal: true

class Session::DestroyJob < ApplicationJob
  queue_as :background

  def perform(session)
    session.destroy
  end
end
