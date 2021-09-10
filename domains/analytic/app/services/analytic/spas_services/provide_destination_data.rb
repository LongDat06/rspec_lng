module Analytic
  module SpasServices
    class ProvideDestinationData
      include Wisper::Publisher 

      def initialize(spas_ids)
        @spas_ids = spas_ids
      end

      def call
        broadcast(:on_spas_import_successful, ais_mapping)
      end

      private
      def ais_mapping
        spas_data.map do |data|
          {
            imo: data.imo_no,
            draught: draught(data.spec.attributes),
            destination: destination(data.spec.attributes),
            eta: eta(data.spec.attributes),
            source: :spas,
            last_ais_updated_at: timestamp(data.spec.attributes)
          }
        end
      end

      def draught(attributes)
        return if attributes['jsmea_voy_deadweightmeasurement_draft_fore'].blank? || attributes['jsmea_voy_deadweightmeasurement_draft_aft'].blank?
        (attributes['jsmea_voy_deadweightmeasurement_draft_fore'].to_f + attributes['jsmea_voy_deadweightmeasurement_draft_aft'].to_f) / 2
      end

      def timestamp(attributes)
        return if attributes['jsmea_voy_dateandtime_utc'].blank?
        attributes['jsmea_voy_dateandtime_utc']
      end

      def eta(attributes)
        return if attributes['jsmea_voy_portinformation_eta_utc'].blank?
        attributes['jsmea_voy_portinformation_eta_utc']
      end

      def destination(attributes)
        return if attributes['jsmea_voy_portinformation_destination1'].blank?
        attributes['jsmea_voy_portinformation_destination1']
      end

      def spas_data
        Analytic::Spas.where(:_id.in => @spas_ids)
      end
    end
  end
end
