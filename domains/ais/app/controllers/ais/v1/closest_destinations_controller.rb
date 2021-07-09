module Ais
  module V1
    class ClosestDestinationsController < BaseController
      def index
        tracking = Ais::Tracking.closest_time(destination_params[:time], destination_params[:imo]).limit(1)
        destination = Ais::VesselDestination
          .imo(destination_params[:imo])
          .closest_time(destination_params[:time], destination_params[:imo])
          .limit(1)
          .map do |object|
            object.tracking = tracking.first
            object
          end
        vessel_destination_jsons = Ais::V1::ClosestDestinationSerializer.new(destination).serializable_hash
        json_response(vessel_destination_jsons)
      end

      private
      def destination_params
        params.permit(:time, :imo)
      end
    end
  end
end
