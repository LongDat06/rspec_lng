module Analytic
  module ChartServices
    class XdfTrend315

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
            'spec.jsmea_mac_boiler_foline_hfo_flowcounter_foc', 
            'spec.jsmea_mac_dieselgeneratorset1_mainline_hfo_flowcounter_foc',
            'spec.jsmea_mac_dieselgeneratorset2_mainline_hfo_flowcounter_foc',
            'spec.jsmea_mac_dieselgeneratorset3_mainline_hfo_flowcounter_foc',
            'spec.jsmea_oil_dieselgeneratorset_fo_in_temp',
          )
      end
    end
  end
end
