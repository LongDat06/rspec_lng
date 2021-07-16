module Ais
  module V1
    class ClosestDestinationSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :imo, :last_ais_updated_at, :draught, :destination, :csm_id, :vessel_id

      attribute :course do |object|
        object.tracking&.course
      end

      attribute :target do |object|
        object.vessel&.target
      end

      attribute :heading do |object|
        object.tracking&.heading
      end

      attribute :course do |object|
        object.tracking&.course
      end

      attribute :target do |object|
        object.vessel&.target || true
      end

      attribute :last_position_updated_at do |object|
        object.tracking&.last_ais_updated_at
      end

      attribute :nav_status_code do |object|
        object.tracking&.nav_status_code
      end

      attribute :speed_over_ground do |object|
        object.tracking&.speed_over_ground
      end

      attribute :eta_at do |object|
        object.eta
      end

      attribute :type do |_|
        'Feature'
      end

      attribute :geometry do |object|
        {
          type: 'Point',
          coordinates: [object.tracking&.longitude, object.tracking&.latitude]
        }
      end

      attribute :coordinates do |object|
        [object.tracking&.longitude, object.tracking&.latitude]
      end
    end
  end
end
