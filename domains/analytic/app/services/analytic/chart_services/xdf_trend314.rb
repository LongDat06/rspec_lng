module Analytic
  module ChartServices
    class XdfTrend314

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
            'spec.jsmea_mac_dieselgeneratorset_fg_flow_ave', 
            'spec.jsmea_mac_dieselgeneratorset_fo_flow_ave',
            'spec.jsmea_mac_forcingvaporizer_gas_out_flow_ave',
          )
      end
    end
  end
end
