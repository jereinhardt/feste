require "active_record"

require "feste/version"
require "feste/engine" if defined?(Rails)
require "feste/user"
require "feste/processor"
require "feste/template_helper" if defined?(Rails)
require "feste/subscription_helper" if defined?(Rails)
require "feste/mailer"

module Feste
  mattr_accessor :options

  def self.table_name_prefix
    "feste_"
  end

  self.options = {
    host: nil,
    email_source: :email
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