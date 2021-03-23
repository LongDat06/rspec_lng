module Analytic
  module ChartServices
    class XdfPress

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
            'spec.jsmea_mac_cargotk1_press_ave', 
            'spec.jsmea_mac_cargotk2_press_ave',
            'spec.jsmea_mac_cargotk3_press_ave',
            'spec.jsmea_mac_cargotk4_press_ave',
          )
      end
    end
  end
end
