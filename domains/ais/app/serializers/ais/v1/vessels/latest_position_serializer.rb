module Ais
  module V1
    module Vessels
      class LatestPositionSerializer
        include FastJsonapi::ObjectSerializer

        attribute :imo, :course, :destination, :draught, :eta_at, :heading, :last_position_updated_at,
                  :latitude, :longitude, :nav_status_code, :speed_over_ground, :vessel_name, :error, :last_port_departure_at

        attribute :type do |_|
          'Feature'
        end

        attribute :geometry do |object|
          {
            type: 'Point',
            coordinates: [object.longitude, object.latitude]
          }
        end

        attribute :properties do |object|
          {
            heading: object.heading,
            vessel_name: object.vessel_name
          }
        end

        attribute :target do |object|
          object.vessel_instance&.target
        end

        attribute :engine_type do |object|
          object.vessel_instance&.engine_type
        end
      end
    end
  end
end
