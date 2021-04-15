module Analytic
  module ChartServices
    class XdfTrend316 < BaseChart
      MODELING = Struct.new(
        :_id,
        :id,
        :spec,
        :difference,
        keyword_init: true
      )

      def call
        Analytic::Sim.collection.aggregate([
          matched,
          project,
          sort,
          limit
        ]).map { |record| MODELING.new(record) }
      end

      private
      def project
        {
          "$project" => {
            "spec.ts" => 1, 
            "spec.jsmea_mac_mainengine_fuelmode" => 1,
            "spec.jsmea_mac_mainengine2_fuelmode" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
