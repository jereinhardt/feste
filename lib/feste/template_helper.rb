module Feste
  module TemplateHelper
    # Return the absolute path to subscriptions#index with the proper
    # subscription token to identify the subscriber.
    #
    # @return [String]
    def subscription_url
      host = Feste.options[:host] ||
        ActionMailer::Base.default_url_options[:host]
      Feste::Engine.routes.url_helpers.subscriptions_url(
        token: @_subscription_token,
        host: host
      )
    end
  end
end