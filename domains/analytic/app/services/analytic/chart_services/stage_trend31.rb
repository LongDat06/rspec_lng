module Analytic
  module ChartServices
    class StageTrend31 < BaseChart
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
            "spec.jsmea_mac_boiler_fo_flow_ave" => 1,
            "spec.jsmea_mac_boiler_fg_flow_ave" => 1,
            "spec.jsmea_mac_dieselgeneratorset_fo_flow_ave" => 1,
            "spec.jsmea_mac_dieselgeneratorset_fg_flow_ave" => 1,
            "spec.jsmea_mac_forcingvaporizer_gas_out_flow_ave" => 1,
            "spec.jsmea_mac_boilerdumpstmcontvalve_opening" => 1
          }.merge!(difference_project)
        }
      end
    end
  end
end
