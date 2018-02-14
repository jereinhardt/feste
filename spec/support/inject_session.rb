require "devise" unless defined?(Warden)

module InjectSession
  include Warden::Test::Helpers

  def inject_session(hash)
    Warden.on_next_request do |proxy|
      hash.each do |key, value|
        proxy.raw_session[key] = value
      end
    end
  end
end

RSpec.configure do |config|
  config.include InjectSession
end