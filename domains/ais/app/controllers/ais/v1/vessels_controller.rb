module Ais
  module V1
    class VesselsController < BaseController
      VESSEL_PER_PAGE = 50

      def create
        opts = VesselForms::Register.new(vessel_params)
        vessel = opts.create
        vessel_jsons = Ais::V1::VesselSerializer.new(vessel).serializable_hash
        json_response(vessel_jsons)
      end

      def index
        page_number = (params[:page] || 1).to_i
        scope = Vessel
          .target(filter_params[:target])
          .imo(filter_params[:imo])
          .engine_type(filter_params[:engine_type])
          .order(created_at: :desc)
        pagy, vessels = pagy(scope, items: VESSEL_PER_PAGE)
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
        vessel = Vessel.find_by_imo!(params[:id])
        VesselForms::Delete.new(vessel).()
        json_response({})
      end

      private
      def vessel_params
        params.permit(:imo, :engine_type, :target)
      end

      def filter_params
        params.permit(:imo, :engine_type, :target)
      end
    end
  end
end
