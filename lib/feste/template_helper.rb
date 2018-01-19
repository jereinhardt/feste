module Feste
  module TemplateHelper    
    def subscription_url
      Feste::Engine.routes.url_helpers.subscription_url(
        token: @_subscription_token,
        host: Feste.options[:host] || ActionMailer::Base.default_url_options[:host]
      )
    end
  end
end