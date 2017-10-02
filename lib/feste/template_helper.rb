module Feste
  module TemplateHelper
    def subscription_url
      cancelled_subscription_url(
        token: @_subscription_token,
        host: Feste.options[:host]
      )
    end
  end
end