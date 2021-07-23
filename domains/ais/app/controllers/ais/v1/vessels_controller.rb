module Ais
  module V1
    class VesselsController < BaseController
      VESSEL_PER_PAGE = 50

      def create
        authorize Ais::Vessel, policy_class: Ais::VesselsPolicy
        opts = VesselForms::Register.new(vessel_params)
        vessel = opts.create
        vessel_jsons = Ais::V1::VesselSerializer.new(vessel).serializable_hash
        json_response(vessel_jsons)
      end

      def index
        authorize Ais::Vessel, policy_class: Ais::VesselsPolicy
        page_number = (params[:page] || 1).to_i
        scope = Vessel
          .target(filter_params[:target])
          .imo(filter_params[:imo])
          .engine_type(filter_params[:engine_type])
          .ecdis_email(filter_params[:ecdis_email])
          .order(created_at: :desc)
        pagy, vessels = pagy(scope, items: VESSEL_PER_PAGE)
        vessels_json = Ais::V1::VesselSerializer.new(vessels).serializable_hash
        pagy_headers_merge(pagy)
        json_response(vessels_json)
      end

      def update
        vessel = policy_scope(Vessel, policy_scope_class: Ais::VesselsPolicy::Scope).find(params[:id])
        vessel.update!(vessel_params)
        json_response({})
      end

      def destroy
        vessel = policy_scope(Vessel, policy_scope_class: Ais::VesselsPolicy::Scope).find_by_imo!(params[:id])
        VesselForms::Delete.new(vessel).()
        json_response({})
      end

      private
      def vessel_params
        params.permit(:imo, :engine_type, :target, :ecdis_email)
      end

      def filter_params
        params.permit(:imo, :engine_type, :target, :ecdis_email)
      end
    end
  end
end
