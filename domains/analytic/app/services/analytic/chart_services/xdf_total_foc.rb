module Analytic
  module ChartServices
    class XdfTotalFoc < BaseChart
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
            "spec.jsmea_mac_ship_mgo_total_flowcounter_foc" => 1,
            "spec.jsmea_mac_ship_fg_flowcounter_fgc" => 1,
            "spec.jsmea_mac_ship_total_include_gcu_fc" => 1,
          }.merge!(difference_project)
        }
      end
    end
  end
end
