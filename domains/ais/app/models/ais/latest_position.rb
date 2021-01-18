module Ais
  class LatestPosition
    include Virtus.model

    attribute :id, Integer
    attribute :imo, String
    attribute :course, Float
    attribute :destination, String
    attribute :draught, Float
    attribute :eta_at, DateTime
    attribute :heading, Integer
    attribute :last_position_updated_at, DateTime
    attribute :latitude, Float
    attribute :longitude, Float
    attribute :nav_status_code, Integer
    attribute :speed_over_ground, Float
    attribute :vessel_name, String
  end
end
