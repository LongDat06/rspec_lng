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

      def update
        vessel = Vessel.find(params[:id])
        vessel.update!(vessel_params)
        json_response({})
      end

      def destroy
        vessel = Vessel.find(params[:id])
        vessel.destroy!
        json_response({})
      end

      private
      def vessel_params
        params.permit(:name, :mmsi, :imo, :callsign, :date_of_build, :ship_type_id, :engine_type)
      end
    end
  end
end
