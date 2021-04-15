module Analytic
  module ChartServices
    class StageTrend32 < BaseChart
      MODELING = Struct.new(
        :_id,
        :id,
        :spec,
        :foc_hfo,
        :foc_mgo,
        :fgc,
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
            "spec.jsmea_nav_gnss_sog" => 1,
            "spec.jsmea_nav_speedlog_log" => 1,
            "spec.jsmea_mac_boiler_foline_hfo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset1_mainline_hfo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset2_mainline_hfo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset3_mainline_hfo_flowcounter_foc" => 1,
            "spec.jsmea_mac_boiler_mgoline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset1_mainline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset2_mainline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset3_mainline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset1_pilotline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset2_pilotline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset3_pilotline_mgo_flowcounter_foc" => 1,
            "spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc" => 1,
            "spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc" => 1
          }.merge!(difference_project)
        }
      end

      def addFields
        {
          "$addFields" => {
            "foc_hfo" => {
              "$sum"=> {
                "$add" => [
                  "$spec.jsmea_mac_boiler_foline_hfo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset1_mainline_hfo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset2_mainline_hfo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset3_mainline_hfo_flowcounter_foc"
                ]
              }
            },
            "foc_mgo" => {
              "$sum"=> {
                "$add" => [
                  "$spec.jsmea_mac_boiler_mgoline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset1_mainline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset2_mainline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset3_mainline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset1_pilotline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset2_pilotline_mgo_flowcounter_foc",
                  "$spec.jsmea_mac_dieselgeneratorset3_pilotline_mgo_flowcounter_foc"
                ] 
              } 
            },
            "fgc" => {
              "$sum"=> {
                "$add" => [
                  "$spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc",
                  "$spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc"
                ]
              }
            },
          }
        }
      end
    end
  end
end
