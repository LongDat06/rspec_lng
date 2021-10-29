module Analytic
  module ChartServices
    class XdfMe < BaseChart
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
            "spec.jsmea_mac_mainengine_fg_in_flow" => 1,
            "spec.jsmea_mac_mainengine2_fg_in_flow" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
