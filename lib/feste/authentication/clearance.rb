module Feste
  module Authentication
    module Clearance
      private 

      def current_user
         @_current_user ||= ::Clearance.
          configuration.
          user_model.
          where(remember_token: cookies[::Clearance.configuration.cookie_name]).
          first
      end
    end
  end
end