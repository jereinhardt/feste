module Feste
  module TemplateHelper
    include Feste::Engine.routes.url_helpers
    
    def subscription_url
      cancelled_subscription_url(
        token: @_subscription_token,
        host: Feste.options[:host]
      )
    end
  end
end