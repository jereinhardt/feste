module Feste
  module User
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def subscriber_email_source(source)
        Feste.options.merge!(email_source: source)
      end
    end

    def email_source
      send(Feste.options[:email_source])
    end
  end
end