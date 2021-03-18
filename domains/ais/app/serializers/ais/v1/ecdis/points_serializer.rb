module Ais
  module V1
    module Ecdis
      class PointsSerializer
        include FastJsonapi::ObjectSerializer

        attributes :ecdis_route_id, :name, :lat, :lon, :leg_type, :turn_radius, :chn_limit,
                   :planned_speed, :speed_min, :speed_max, :course, :length, :do_plan, :do_left,
                   :hfo_plan, :hfo_left, :eta_day, :eta_time, :original_eta
        
        attribute :geometry do |object|
          {
            type: 'Point',
            coordinates: [object.lon, object.lat]
          }
        end
      end
    end
  end
end
