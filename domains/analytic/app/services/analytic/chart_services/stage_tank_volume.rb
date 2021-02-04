module Analytic
  module ChartServices
    class StageTankVolume

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
          .order_by('spec.timestamp' => 1)
          .where({'spec.timestamp' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo.to_i)
          .only(
            '_id',
            'spec.timestamp',
            'spec.jsmea_mac_cargotk1_volume_percent',
            'spec.jsmea_mac_cargotk2_volume_percent',
            'spec.jsmea_mac_cargotk3_volume_percent',
            'spec.jsmea_mac_cargotk4_volume_percent',
            'spec.jsmea_mac_cargotk_total_volume_ave'
          )
      end
    end
  end
end
