require_relative "./clearance"
require_relative "./custom"
require_relative "./devise"

module Feste
  module Authentication
    def self.included(klass)
      if Feste.options[:authenticate_with] == :clearance
        klass.include Feste::Authentication::Clearance
      elsif Feste.options[:authenticate_with] == :devise
        klass.include Feste::Authentication::Devise
      elsif Feste.options[:authenticate_with].is_a?(Proc)
        klass.include Feste::Authentication::Custom
      else
        klass.include Feste::Authentication::InstanceMethods
      end
    end

    module InstanceMethods
      def current_user
        nil
      end
    end
  end
end