module Feste
  module TemplateHelper
    # Return the absolute path to subscriptions#index with the proper
    # subscription token to identify the subscriber.
    #
    # @return [String]
    def subscription_url
      host = Feste.options[:host] ||
        ActionMailer::Base.default_url_options[:host]
      if main_app.respond_to?(:subscriptions_url)
        main_app.subscriptions_url(token: @_subscription_token, host: host)
      else
        feste.subscriptions_url(token: @_subscription_token, host: host)
      end
    end
  end
end