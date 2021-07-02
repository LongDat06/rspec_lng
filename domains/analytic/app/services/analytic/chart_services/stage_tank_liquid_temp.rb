module Analytic
  module ChartServices
    class StageTankLiquidTemp < BaseChart
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
          group,
          sort,
          limit
        ]).map { |record| MODELING.new(record) }
      end

      private
      def project
        {
          "$project" => {
            "spec.ts" => 1, 
            "spec.jsmea_mac_cargotk1_liquid_temp" => 1,
            "spec.jsmea_mac_cargotk2_liquid_temp" => 1,
            "spec.jsmea_mac_cargotk3_liquid_temp" => 1,
            "spec.jsmea_mac_cargotk4_liquid_temp" => 1
          }.merge!(difference_project)
        }
      end
    end
  end
end
