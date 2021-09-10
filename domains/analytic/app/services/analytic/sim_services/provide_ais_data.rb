module Analytic
  module SimServices
    class ProvideAisData
      include Wisper::Publisher 

      def initialize(sim_ids)
        @sim_ids = sim_ids
      end

      def call
        broadcast(:on_sim_import_successful, ais_mapping)
      end

      private
      def ais_mapping
        sim_data.map do |data|
          {
            imo: data.imo_no,
            latitude: latitude_attrs(data.spec.attributes),
            longitude: longitude_attrs(data.spec.attributes),
            speed_over_ground: data.spec.attributes['jsmea_nav_gnss_sog'],
            heading: data.spec.attributes['jsmea_nav_compass_heading_direction']&.to_f&.round,
            draught: draught(data.spec.attributes),
            is_valid: true,
            last_ais_updated_at: data.spec.attributes['ts'],
            source: :sim
          }
        end
      end

      def draught(attributes)
        return if attributes['jsmea_voy_draftgauge_draft_forward'].blank? || attributes['jsmea_voy_draftgauge_draft_aft'].blank?
        (attributes['jsmea_voy_draftgauge_draft_forward'].to_f + attributes['jsmea_voy_draftgauge_draft_aft'].to_f) / 2
      end

      def longitude_attrs(attributes)
        return if attributes['jsmea_nav_gnss_start_ccrp_lon'].blank? || attributes['jsmea_nav_gnss_start_ccrp_lon_ew'].blank?
        convert_lat_lon(attributes['jsmea_nav_gnss_start_ccrp_lon'], attributes['jsmea_nav_gnss_start_ccrp_lon_ew']) 
      end

      def latitude_attrs(attributes)
        return if attributes['jsmea_nav_gnss_start_ccrp_lat'].blank? || attributes['jsmea_nav_gnss_start_ccrp_lat_ns'].blank?
        convert_lat_lon(attributes['jsmea_nav_gnss_start_ccrp_lat'], attributes['jsmea_nav_gnss_start_ccrp_lat_ns'])
      end

      # Y.YY -> 0 deg Y.YY min
      # YY.YY -> 0 deg YY.YY min
      # XYY.YY -> X deg YY.YY min
      # XXYY.YY -> XX deg YY.YY min
      # XXXYY.YY -> XXX deg YY.YY min
      def convert_lat_lon(position_first, position_second)
        position  = position_first.is_a?(String) ? position_second.to_s : position_first.to_s
        direction = position_first.is_a?(String) ? position_first : position_second
        if check_digit(position) == 1 || check_digit(position) == 2
          dd = 0 + position.to_f / 60
        elsif check_digit(position) == 3
          dd = position[0..0].to_i + position[1..-1].to_f / 60
        elsif check_digit(position) == 4
          dd = position[0..1].to_i + position[2..-1].to_f / 60
        elsif check_digit(position) == 5
          dd = position[0..2].to_i + position[3..-1].to_f / 60
        end
        dd = dd * -1 if (direction == "S" || direction == "W")
        dd
      end

      def check_digit(number)
        Math.log10(number.to_f).to_i + 1
      rescue FloatDomainError
        nil
      end

      def sim_data
        Analytic::Sim.where(:_id.in => @sim_ids)
      end
    end
  end
end
