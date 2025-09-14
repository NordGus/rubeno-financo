class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_key_by_token, only: %i[ edit update ]

  def new
  end

  def create
    character_by_email = Character.find_by(email_address: params[:username])
    character_by_tag = Character.find_by(tag: params[:username])

    PasswordsMailer.reset(character_by_email || character_by_tag).deliver_later if character_by_email || character_by_tag

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_key_by_token
      @key = PasswordKey.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
