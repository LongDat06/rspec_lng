module Ais
  module V1
    class TrackingSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :latitude, :longitude, :heading, :speed_over_ground,
                :last_ais_updated_at, :created_at, :updated_at, :nav_status_code,
                :vessel_id, :course, :collection_type, :source, :is_valid, :imo

      attribute :type do |_|
        'Feature'
      end

      attribute :geometry do |object|
        {
          type: 'Point',
          coordinates: [object.longitude, object.latitude]
        }
      end
    end
  end
end
