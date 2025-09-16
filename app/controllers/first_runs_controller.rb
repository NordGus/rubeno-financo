class FirstRunsController < ApplicationController
  allow_unauthenticated_access

  before_action :prevent_repeats

  def show
    @character = FirstRunForm.new
  end

  def create
    @character = FirstRunForm.new(character_params)

    if @character.valid?
      key, archive = FirstRun.create!(@character)

      start_new_session_for key

      Current.session.update(archive:)

      redirect_to root_url
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

    def prevent_repeats
      redirect_to root_url if Character.any?
    end

    def character_params
      params.require(:first_run).permit(:email_address, :username, :password, :password_confirmation)
    end
end
