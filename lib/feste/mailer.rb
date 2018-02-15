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

        if recipient_subscribed?(subscriber)
          generate_subscription_token!(subscriber)
          message = super
        else
          nil
        end
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

      def recipient_subscribed?(subscriber)
        category = self.action_categories[action_name.to_sym] || 
          self.action_categories[:all]
        if subscriber.present? && category.present?
          !Feste::Subscription.find_or_create_by(
            category: category,
            subscriber: subscriber
          ).canceled?
        else
          true
        end
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