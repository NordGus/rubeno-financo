# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  SESSION_IDENTIFIER_KEY = :session_token

  private_constant :SESSION_IDENTIFIER_KEY

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.includes(:archive, :character).find_by(token: cookies.signed[SESSION_IDENTIFIER_KEY]) if cookies.signed[SESSION_IDENTIFIER_KEY]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to main_app.new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(key)
      key.character.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session

        # Enforcing a 6 hours lifespan for the user session. I'm doing this as a paranoia induced security feature.
        # In case the user's cookies are compromised, any undesired access can be mitigated under the presumption
        # that the session is probably already dead.
        Session::DestroyJob.set(wait: Session::MAX_LIFESPAN).perform_later(session)

        cookies.signed.permanent[SESSION_IDENTIFIER_KEY] = { value: session.token, httponly: true, same_site: :lax }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(SESSION_IDENTIFIER_KEY)
    end
end
