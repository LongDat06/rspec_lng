module Analytic
  module ChartServices
    class ChartBase
      def initialize
        @schema = YAML.load_file("#{Analytic::Engine.root}/config/sim_chart_schema.yml")
      end

      def call
      end
    end
  end
end
