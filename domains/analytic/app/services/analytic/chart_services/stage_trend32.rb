module Analytic
  module ChartServices
    class StageTrend32
      MODELING = Struct.new(
        :_id,
        :id,
        :spec,
        :foc_hfo,
        :foc_mgo,
        :fgc,
        keyword_init: true
      )

      def initialize(from_time, to_time, imo)
        @from_time = from_time.to_datetime
        @to_time = to_time.to_datetime
        @imo = imo.to_i
      end

      def call
        Analytic::Sim.collection.aggregate([
          matched,
          project,
          addFields
        ]).map { |record| MODELING.new(record) }
      end

      private
      def matched
        {
          "$match" => {
            "$and" => [
              "spec.timestamp" => { "$gte" => @from_time, "$lte" => @to_time  }, 
              "imo_no" => @imo
            ]
          }
        }
      end

      def project
        {
          "$project" => {
            "spec.timestamp" => 1, 
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
          }
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
