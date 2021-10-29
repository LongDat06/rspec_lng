module Analytic
  module ChartServices
    class StageTankVolume < BaseChart
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
            "spec.jsmea_mac_cargotk1_volume" => 1,
            "spec.jsmea_mac_cargotk2_volume" => 1,
            "spec.jsmea_mac_cargotk3_volume" => 1,
            "spec.jsmea_mac_cargotk4_volume" => 1,
            "spec.jsmea_mac_cargotk5_volume" => 1,
            "spec.jsmea_mac_cargotk1_volume_percent" => 1,
            "spec.jsmea_mac_cargotk2_volume_percent" => 1,
            "spec.jsmea_mac_cargotk3_volume_percent" => 1,
            "spec.jsmea_mac_cargotk4_volume_percent" => 1,
            "spec.jsmea_mac_cargotk5_volume_percent" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
