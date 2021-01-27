module Ais
  module V1
    class VesselsController < BaseController
      VESSEL_PER_PAGE = 20

      def create
        Vessel.create!(vessel_params)
        json_response({})
      end

      def index
        page_number = (params[:page] || 1).to_i
        pagy, vessels = pagy_countless(Vessel.order(created_at: :desc), items: VESSEL_PER_PAGE)
        vessels_json = Ais::V1::VesselSerializer.new(vessels).serializable_hash
        pagy_headers_merge(pagy)
        json_response(vessels_json)
      end

      private
      def vessel_params
        params.permit(:name, :mmsi, :imo, :callsign, :date_of_build, :ship_type_id)
      end
    end
  end
end
