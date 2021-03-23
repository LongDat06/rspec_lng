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
          .order_by('spec.ts' => 1)
          .where({'spec.ts' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo)
          .only(
            '_id',
            'spec.ts',
            'spec.jsmea_oil_dieselgeneratorset_fo_in_temp',
            'spec.jsmea_mac_ship_mgo_total_flowcounter_foc',
            'spec.jsmea_mac_ship_fg_flowcounter_fgc'
          )
      end
    end
  end
end
