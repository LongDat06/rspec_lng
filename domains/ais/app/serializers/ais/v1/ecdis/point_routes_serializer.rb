module Ais
  module V1
    module Ecdis
      class PointRoutesSerializer
        include FastJsonapi::ObjectSerializer

        attributes :imo, :etd, :eta, :max_power, :speed, :etd_wpno,
                   :eta_wpno, :optimized, :budget, :received_at

        attribute  :ecdis_points, class_name: PointsSerializer do |object|
          object.ecdis_points.map do |point|
            point.attributes.merge!(
              geometry: {
                type: 'Point',
                coordinates: [point.lon, point.lat]
              }
            )
          end
        end
      end
    end
  end
end
