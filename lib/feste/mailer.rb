module Feste
  module Mailer    
    def self.included(klass)
      klass.include InstanceMethods
      klass.extend ClassMethods
      klass.send(:add_template_helper, TemplateHelper) if defined?(Rails)
      klass.class_eval do
        class_attribute :action_categories
        self.action_categories = {}
      end
    end

    module InstanceMethods
      def mail(headers = {}, &block)
        return message if @_mail_was_called && headers.blank? && !block

        message = super

        generate_subscription_token!(message)
        Feste::Processor.new(message, self, action_name).process
        message
      end

      private

      def generate_subscription_token!(message)
        byebug
        if (
          self.action_categories[action_name.to_sym] || 
          self.action_categories[:all]
        )
          @_subscription_token ||= Feste::Subscription.
            get_token_for(message.to.first, self, action_name)
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