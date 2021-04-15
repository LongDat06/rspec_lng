module Analytic
  module ChartServices
    class XdfBoilOffRate < BaseChart
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
            "spec.jsmea_mac_cargotk_bor_include_fv" => 1,
            "spec.jsmea_mac_cargotk_bor_exclude_fv" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
