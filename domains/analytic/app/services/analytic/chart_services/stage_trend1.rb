module Analytic
  module ChartServices
    class StageTrend1 < BaseChart
      MODELING = Struct.new(
        :_id,
        :id,
        :spec,
        :total_foc,
        :difference,
        keyword_init: true
      )

      def call
        Analytic::Sim.collection.aggregate([
          matched,
          project,
          addFields,
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
            "spec.jsmea_mac_boiler_total_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc" => 1
          }.merge!(difference_project)
        }
      end

      def addFields
        {
          "$addFields" => {
            "total_foc" => {
              "$sum"=> { 
                "$add" => [
                  "$spec.jsmea_mac_boiler_total_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc"
                ]
              }
            }
          }
        }
      end
    end
  end
end
