module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_user || reject_unauthorized_connection
    end

    private
      def set_current_user
        if (session = Session.find_by(token: cookies.signed[Authentication::SESSION_IDENTIFIER_KEY]))
          self.current_user = session.character
        end
      end
  end
end
