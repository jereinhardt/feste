require "active_record"

require "feste/version"
require "feste/engine" if defined?(Rails)
require "feste/authentication/authentication"
require "feste/authentication/clearance"
require "feste/authentication/custom"
require "feste/authentication/devise"
require "feste/user"
require "feste/template_helper"
require "feste/mailer"

module Feste
  mattr_accessor :options

  def self.table_name_prefix
    "feste_"
  end

  self.options = {
    categories: [],
    host: nil,
    email_source: :email,
    authenticate_with: nil,
    event_subscriber: nil
  }

  def self.configure
    begin
      yield(Config)
    rescue NoConfigurationError => e
      puts "FESTE CONFIGURATION WARNING: #{e}"
    end
  end

  module Config
    def self.method_missing(meth, *args, &block)
      key = meth.to_s.slice(0, meth.to_s.length - 1).to_sym
      if Feste.options.has_key?(key)
        Feste.options[key] = args[0]
      else
        raise(
          NoConfigurationError,
          "There is no configuration option for #{key}"
        )
      end
    end
  end

  class NoConfigurationError < StandardError
  end
end