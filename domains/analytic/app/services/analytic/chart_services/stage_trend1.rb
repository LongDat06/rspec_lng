module Analytic
  module ChartServices
    class StageTrend1 < BaseChart
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
            "spec.jsmea_mac_mainturb_load" => 1,
            "spec.jsmea_mac_mainturb_revolution" => 1,
          }.merge!(difference_project)
        }
      end

    end
  end
end
