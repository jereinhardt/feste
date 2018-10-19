module Feste
  module Mailer    
    def self.included(klass)
      klass.include InstanceMethods
      klass.send(:add_template_helper, TemplateHelper)
    end

    module InstanceMethods
      # Returns a Mail object or nil based on if the action has been categorized
      # and if the subscriber is unsubscribed
      # @param [Hash, &block]
      #
      # The subscriber is supplied as an argument in the headers through the
      # :subscriber key. The :subscriber key is stripped from the headers before
      # they are given as an argument to the superclass.  If no subscriber is
      # provided, then one will be inferred from the :to header.
      #
      # @return [Mail, nil], the Mail object or nil if the subscriber is
      # unsubscribed
      def mail(headers = {}, &block)
        if current_action_category.present?
          return message if @_mail_was_called && headers.blank? && !block

          email = headers[:to].is_a?(String) ? headers[:to] : headers[:to].first
          subscriber = headers[:subscriber] ||
            Feste::Subscription.find_subscribed_user(email)
          headers = headers.except(:subscriber)

          if recipient_subscribed?(subscriber)
            generate_subscription_token!(subscriber)
            message = super(headers, &block)
          else
            nil
          end          
        else
          super(headers, &block)
        end
      end

      private

      def current_action_category
        @category ||= Feste::Category.
          find_by_mailer("#{self.class.to_s}##{action_name}")
      end

      def generate_subscription_token!(subscriber)
        @_subscription_token ||= Feste::Subscription.
          get_token_for(subscriber, current_action_category)
      end

      def recipient_subscribed?(subscriber)
        !Feste::Subscription.find_or_create_by(
          category: current_action_category,
          subscriber: subscriber
        )&.canceled?
      end
    end
  end
end