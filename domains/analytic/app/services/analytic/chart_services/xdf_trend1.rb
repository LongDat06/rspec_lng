module Analytic
  module ChartServices
    class XdfTrend1
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
        Analytic::Sim
          .where({'spec.timestamp' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo)
          .only(
            '_id',
            'spec.timestamp', 
            'spec.jsmea_mac_mainengine_load', 
            'spec.jsmea_mac_mainengine2_load',
            'spec.jsmea_mac_mainengine_revolution',
            'spec.jsmea_mac_mainengine2_revolution',
            'spec.jsmea_nav_gnss_sog'
          )
      end
    end
  end
end
