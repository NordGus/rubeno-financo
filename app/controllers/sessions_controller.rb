class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  allow_out_of_archive_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  before_action :ensure_protagonist_exists, only: :new

  def new
  end

  def create
    if (key = PasswordKey.authenticate(username: params[:username], password: params[:password]))
      key.update!(last_sign_in_at: Time.zone.now)
      start_new_session_for key
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address, tag or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def ensure_protagonist_exists
    redirect_to first_run_url if Character.none?
  end
end
