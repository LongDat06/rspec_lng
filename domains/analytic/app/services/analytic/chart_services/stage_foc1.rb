module Analytic
  module ChartServices
    class StageFoc1 < BaseChart
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
            "spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc" => 1,
            "spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc" => 1,
            "spec.jsmea_mac_boiler_mgoline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
