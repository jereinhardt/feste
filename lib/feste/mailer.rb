module Feste
  module Mailer
    def self.included(klass)
      klass.send(:prepend, InstanceMethods)
      klass.extend ClassMethods
      klass.class_eval do
        class_attribute :feste_whitelist
        class_attribute :feste_blacklist
        self.feste_whitelist = []
        self.feste_blacklist = []
        attr_accessor :subscribable_mailer_name
      end
    end

    module InstanceMethods
      def mail(headers = {}, &block)
        return message if @_mail_was_called && headers.blank? && !block

        action = caller_locations(1,1)[0].label.to_sym
        message = super

        Feste::Processor.new(message, self, action, @_feste_user).process
        message
      end

      def subscriber(user)
        @_feste_user = user
      end

      def subscription_url
        cancelled_subscription_url(token: subscription_token)
      end

      def subscription_token
        action = caller_locations(1,1)[0].label.to_s
        mailer = self.class.name
        user = @_feste_user
        @_subscription_token ||= Feste::CancelledSubscription.get_token_for(user, mailer, action)
      end
    end

    module ClassMethods
      def allow_subscriptions(only: [], except: [])
        if only.any?
          self.feste_whitelist = only
        elsif except.any?
          self.feste_blacklist = except
        end
      end
    end
  end
end