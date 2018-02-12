module Feste
  module Mailer    
    def self.included(klass)
      klass.include InstanceMethods
      klass.extend ClassMethods
      klass.send(:add_template_helper, TemplateHelper)
      klass.class_eval do
        class_attribute :action_categories
        self.action_categories = {}
      end
    end

    module InstanceMethods
      def mail(headers = {}, &block)
        return message if @_mail_was_called && headers.blank? && !block

        email = headers[:to].is_a?(String) ? headers[:to] : headers[:to].first
        subscriber = Feste::Subscription.find_subscribed_user(email)
        generate_subscription_token!(subscriber)

        message = super

        if process_email_subscription?(subscriber)
          Feste::Processor.new(message, self, action_name).process
        end
        message
      end

      private

      def generate_subscription_token!(subscriber)
        if process_email_subscription?(subscriber)
          @_subscription_token ||= Feste::Subscription.
            get_token_for(subscriber, self, action_name)
        end
      end

      def process_email_subscription?(subscriber)
        subscriber.present? && (
          self.action_categories[action_name.to_sym] ||
            self.action_categories[:all]
        )
      end
    end

    module ClassMethods
      def categorize(meths = [], as:)
        actions = meths.empty? ? [:all] : meths
        actions.each { |action| self.action_categories[action.to_sym] = as }
      end

      def action_methods
        feste_methods = %w[
          action_categories action_categories= action_categories?
        ]
        Set.new(super - feste_methods)
      end
    end
  end
end