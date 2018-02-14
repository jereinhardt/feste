module Feste
  module Authentication
    module Devise
      private

      def current_user
        main_app.scope.env['warden'].user
      end
    end
  end
end