module Analytic
  module ChartServices
    class StageTrend33

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
          .order_by('spec.ts' => 1)
          .where({'spec.ts' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo.to_i)
          .only(
            '_id',
            'spec.ts', 
            'spec.jsmea_mac_boiler_fuelmode', 
            'spec.jsmea_mac_boiler2_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset1_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset2_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset3_fuelmode'
          )
      end
    end
  end
end
