module Ais
  module V1
    class VesselSerializer
      include FastJsonapi::ObjectSerializer

      attribute :id, :imo, :mmsi, :name, :callsign, :date_of_build, :created_at, :updated_at
    end
  end
end
