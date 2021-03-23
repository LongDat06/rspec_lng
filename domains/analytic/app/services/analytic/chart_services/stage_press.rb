module Analytic
  module ChartServices
    class StagePress
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
            'spec.jsmea_mac_cargotk1_press_ave', 
            'spec.jsmea_mac_cargotk2_press_ave',
            'spec.jsmea_mac_cargotk3_press_ave',
            'spec.jsmea_mac_cargotk4_press_ave',
            'spec.jsmea_mac_holdspace1_press_ave',
            'spec.jsmea_mac_holdspace2_press_ave',
            'spec.jsmea_mac_holdspace3_press_ave',
            'spec.jsmea_mac_holdspace4_press_ave'
          )
      end
    end
  end
end
