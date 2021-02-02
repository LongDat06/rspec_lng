module Analytic
  module ChartServices
    class StageTankEquator

      def initialize(from_time, to_time, imo)
        @from_time = from_time.to_datetime
        @to_time = to_time.to_datetime
        @imo = imo
      end

      def call
        sim_data
      end

      private

      def sim_data
        Analytic::Sim
          .where({'spec.timestamp' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo.to_i)
          .only(
            '_id',
            'spec.timestamp', 
            'spec.jsmea_mac_cargotk1_equator_temp', 
            'spec.jsmea_mac_cargotk2_equator_temp',
            'spec.jsmea_mac_cargotk3_equator_temp',
            'spec.jsmea_mac_cargotk4_equator_temp'
          )
      end
    end
  end
end
