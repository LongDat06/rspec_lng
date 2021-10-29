module Analytic
  module ChartServices
    class CmStagePressHold < BaseChart
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
            "spec.jsmea_mac_holdspace1_press_ave" => 1,
            "spec.jsmea_mac_holdspace2_press_ave" => 1,
            "spec.jsmea_mac_holdspace3_press_ave" => 1,
            "spec.jsmea_mac_holdspace4_press_ave" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
