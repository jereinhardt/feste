module Feste
  module Admin
    class Engine < ::Rails::Engine
      isolate_namespace Feste::Admin
    end
  end
end