module Feste
  module Authentication
    module Custom
      private
      
      def current_user
        Feste.options[:authenticate_with].call(self)
      end
    end
  end
end