module Analytic
  module ChartServices
    class StageTrend31

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
            'spec.jsmea_mac_boiler_fo_flow_ave',
            'spec.jsmea_mac_boiler_fg_flow_ave',
            'spec.jsmea_mac_dieselgeneratorset_fo_flow_ave',
            'spec.jsmea_mac_dieselgeneratorset_fg_flow_ave',
            'spec.jsmea_mac_forcingvaporizer_gas_out_flow_ave',
            'spec.jsmea_mac_boilerdumpstmcontvalve_opening'
          )
      end
    end
  end
end
