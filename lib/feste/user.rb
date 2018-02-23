module Feste
  module User
    def self.included(klass)
      klass.include InstanceMethods
      klass.class_eval do
        has_many(
          :subscriptions,
          class_name: "Feste::Subscription",
          as: :subscriber
        )
      end
    end

    module InstanceMethods
      # Return the email address of the subscriber.
      #
      # @return [String]
      def email_source
        send(Feste.options[:email_source])
      end
    end
  end
end