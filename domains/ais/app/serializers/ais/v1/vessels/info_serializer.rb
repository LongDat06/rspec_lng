module Ais
  module V1
    module Vessels
      class InfoSerializer
        include FastJsonapi::ObjectSerializer

        attribute :imo, :name, :mmsi, :callsign, :date_of_build, :engine_type

      end
    end
  end
end
