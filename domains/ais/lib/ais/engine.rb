module Ais
  class Engine < ::Rails::Engine
    isolate_namespace Ais
    config.generators.api_only = true
  end
end
