module Analytic
  module SpasServices
    class LastDeparture
      include Wisper::Publisher 

      DEPATURE_FLAG = '3:DEP'.freeze

      def initialize(imo)
        @imo = imo
      end

      def call
        return if last_dep.blank?
        last_dep.spec.attributes
        broadcast(:on_dep_successful, { imo: @imo, spec: last_dep.spec.attributes })
      end

      private
      def last_dep
        Analytic::Spas
          .order_by('spec.ts' => -1)
          .where(imo_no: @imo.to_i)
          .where('spec.jsmea_voy_voyageinformation_category' => DEPATURE_FLAG)
          .only(
            '_id',
            'spec.ts', 
            'spec.jsmea_voy_voyageinformation_category',
            'spec.jsmea_voy_dateandtime_lt',
            'spec.jsmea_voy_portinformation_portcode',
          )
          .limit(1)
          .first
      end
    end
  end
end
