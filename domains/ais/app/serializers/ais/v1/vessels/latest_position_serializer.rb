module Ais
  module V1
    module Vessels
      class LatestPositionSerializer
        include FastJsonapi::ObjectSerializer

        attribute :imo, :course, :destination, :draught, :eta_at, :heading, :last_position_updated_at,
                  :latitude, :longitude, :nav_status_code, :speed_over_ground, :vessel_name, :error

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
      end
    end
  end
end
