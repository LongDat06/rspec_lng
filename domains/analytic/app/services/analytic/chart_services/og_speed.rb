module Analytic
  module ChartServices
    class OgSpeed < BaseChart
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
            "spec.jsmea_nav_gnss_sog" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
