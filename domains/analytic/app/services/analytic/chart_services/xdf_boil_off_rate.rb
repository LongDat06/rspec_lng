module Analytic
  module ChartServices
    class XdfBoilOffRate

      def initialize(from_time, to_time, imo)
        @from_time = from_time.to_datetime
        @to_time = to_time.to_datetime
        @imo = imo.to_i
      end

      def call
        Analytic::Sim
          .where({'spec.timestamp' => { '$gte' => @from_time, '$lte' => @to_time }})
          .where(imo_no: @imo)
          .only(
            '_id',
            'spec.timestamp', 
            'spec.jsmea_mac_cargotk_bor_include_fv', 
            'spec.jsmea_mac_cargotk_bor_exclude_fv',
          )
      end
    end
  end
end
