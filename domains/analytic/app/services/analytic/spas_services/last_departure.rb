module Analytic
  module SpasServices
    class LastDeparture
      include Wisper::Publisher 

      EXCLUDE_PORT_LOCODE = 'PABLB;PACTB;EGSCA;EGSUZ'.freeze
      DEPATURE_FLAG = '3:DEP'.freeze

      def initialize(imo)
        @imo = imo
      end

      def call
        return if last_dep.blank?
        port_code = last_dep.spec.attributes[:jsmea_voy_portinformation_portcode]
        return if port_code.present? && EXCLUDE_PORT_LOCODE.include?(port_code.strip)
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
            'spec.jsmea_voy_dateandtime_utc',
            'spec.jsmea_voy_portinformation_portcode',
          )
          .limit(1)
          .first
      end
    end
  end
end
