module Analytic
  module ChartServices
    class StageTrend1
      MODELING = Struct.new(
        :_id,
        :id,
        :spec,
        :total_foc,
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
            "spec.jsmea_mac_mainturb_load" => 1,
            "spec.jsmea_mac_mainturb_revolution" => 1,
            "spec.jsmea_mac_boiler_total_flowcounter_foc" => 1,
            "spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc" => 1
          }
        }
      end

      def addFields
        {
          "$addFields" => {
            "total_foc" => { 
              "$sum"=> { 
                "$multiply" => [ 
                  "$jsmea_mac_boiler_total_flowcounter_foc", 
                  "$jsmea_mac_dieselgeneratorset_total_flowcounter_foc"
                ] 
              } 
            }
          }
        }
      end
    end
  end
end
