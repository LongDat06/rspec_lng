module Analytic
  module ChartServices
    class XdfTankEquatorTemp

      def initialize(from_time, to_time, imo)
        @from_time = from_time.to_datetime
        @to_time = to_time.to_datetime
        @imo = imo.to_i
      end

      def call
        Analytic::Sim
          .order_by('spec.timestamp' => 1)
          .where({'spec.timestamp' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo)
          .only(
            '_id',
            'spec.timestamp', 
            'spec.jsmea_mac_cargotk1_equator_temp', 
            'spec.jsmea_mac_cargotk2_equator_temp',
            'spec.jsmea_mac_cargotk3_equator_temp',
            'spec.jsmea_mac_cargotk4_equator_temp',
          )
      end
    end
  end
end
