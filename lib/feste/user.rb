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

      # Returns the subscriber's subscriptions that are associated with a
      # category.  This is a contingency for applications that upgraded from
      # 0.3 to 0.4.  In the event that there are older subscription records
      # that were associated with a category that was no longer in use at the
      # time the application upgraded, they will not be matched with an active
      # category record at the time of the upgrade, and therefore should not
      # be returned
      #
      # @return [ActiveRecord::Association]
      def active_subscriptions
        subscriptions.where("category_id IS NOT NULL")
      end
    end
  end
end