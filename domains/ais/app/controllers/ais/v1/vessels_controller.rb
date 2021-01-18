module Ais
  module V1
    class VesselsController < BaseController
      def create
        Vessel.create!(vessel_params)
        json_response({})
      end

      private
      def vessel_params
        params.permit(:name, :mmsi, :imo, :callsign, :date_of_build, :ship_type_id)
      end
    end
  end
end
