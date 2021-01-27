module Analytic
  module ChartServices
    class Press
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
