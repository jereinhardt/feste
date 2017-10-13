module Feste
  module Mailer    
    def self.included(klass)
      klass.include InstanceMethods
      klass.extend ClassMethods
      klass.send(:add_template_helper, TemplateHelper) if defined?(Rails)
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
        
        mailer = self.class.name
        action = caller_locations.find do |l| 
          self.class.instance_methods(false).include?(l.label.to_sym)
        end.label

        generate_subscription_token!(mailer, action)

        message = super

        Feste::Processor.new(message, self, action, @_feste_user).process
        message
      end

      def subscriber(user)
        @_feste_user = user
      end

      private

      def generate_subscription_token!(mailer, action)
        user = @_feste_user
        @_subscription_token ||= 
          Feste::CancelledSubscription.get_token_for(user, mailer, action)
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