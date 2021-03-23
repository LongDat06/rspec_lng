module Analytic
  module ChartServices
    class XdfInnerSurfaceTemp

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
            'spec.jsmea_mac_cargotk1_innersurface_upp_temp',
            'spec.jsmea_mac_cargotk1_innersurface_low_temp',
            'spec.jsmea_mac_cargotk2_innersurface_upp_temp',
            'spec.jsmea_mac_cargotk2_innersurface_low_temp',
            'spec.jsmea_mac_cargotk3_innersurface_upp_temp',
            'spec.jsmea_mac_cargotk3_innersurface_low_temp',
            'spec.jsmea_mac_cargotk4_innersurface_upp_temp',
            'spec.jsmea_mac_cargotk4_innersurface_low_temp',
          )
      end
    end
  end
end
