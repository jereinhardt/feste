module Feste
  class Engine < ::Rails::Engine
    isolate_namespace Feste

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.assets false
      g.helper false
    end

    initializer "feste" do |app|
      app.config.assets.precompile << proc do |path| 
        path =~ /\Afeste\/application\.(js|css)\z/
      end
    end
  end
end