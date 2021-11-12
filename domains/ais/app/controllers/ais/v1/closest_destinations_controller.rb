module Ais
  module V1
    class ClosestDestinationsController < BaseController
      def index
        authorize Ais::VesselDestination, policy_class: Ais::ClosestDestinationsPolicy
        tracking = Ais::Tracking.closest_time(destination_params[:time], destination_params[:imo])
        vessel = Ais::Vessel.find_by(imo: destination_params[:imo])
        from_time = destination_params[:from_time].presence || vessel.last_port_departure_at
        to_time = destination_params[:to_time].presence || Time.current.utc
        destination = Ais::VesselDestination
          .where('last_ais_updated_at >= ? AND last_ais_updated_at <= ?', from_time, to_time)
          .imo(destination_params[:imo])
          .closest_time(destination_params[:time], destination_params[:imo])
          .limit(1)
          .first
        destination = destination.presence || VesselDestination.new(imo: destination_params[:imo], source: nil)
        destination.tracking = tracking
        vessel_destination_jsons = Ais::V1::ClosestDestinationSerializer.new(destination).serializable_hash
        json_response(vessel_destination_jsons)
      end

      private
      def destination_params
        params.permit(:time, :imo, :tracking_id, :from_time, :to_time)
      end
    end
  end
end
