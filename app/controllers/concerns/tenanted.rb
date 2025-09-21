# frozen_string_literal: true

module Tenanted
  extend ActiveSupport::Concern

  included do
    before_action :require_tenant
    before_action :enforce_tenant
  end

  class_methods do
    def allow_out_of_archive_access(**options)
      skip_before_action :require_tenant, **options
      skip_before_action :enforce_tenant, **options
    end
  end

  private

  # We need to validate that current session has an archive set to display data. If not, we need to send the character to
  # select an archive to operate with.
  def require_tenant
    redirect_to app_archives_url unless Current.archive.present?
  end

  # We need to validate that current character has access to the current archive, if not we clear the archive from the current
  # session and redirected them to select an archive to operate with.
  def enforce_tenant
    unless Current.archive.is_accessible_by(Current.character.id)
      redirect_to app_archives_url if Current.session.update!(archive_id: nil)
    end
  end
end
