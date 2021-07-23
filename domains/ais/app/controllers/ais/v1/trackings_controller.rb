module Ais
  module V1
    class TrackingControllerInvalidParameters < ActionController::BadRequest; end
    class TrackingsController < BaseController
      before_action :validate_params, only: [:index]

      def index
        authorize Ais::Tracking, policy_class: Ais::TrackingsPolicy
        vessel = Ais::Vessel.find_by(imo: tracking_params[:imos])
        tracking_params[:from_time] = tracking_params[:from_time].presence || vessel.last_port_departure_at
        trackings = Ais::TrackingServices::TrackingPerHour.new(
          from_time: tracking_params[:from_time], 
          to_time: tracking_params[:to_time],
          imo: vessel.imo
        ).get
        trackig_jsons = Ais::V1::TrackingSerializer.new(trackings).serializable_hash
        json_response(trackig_jsons)
      end

      private
      def tracking_params
        @tracking_params ||= params.permit(:from_time, :to_time, imos: [])
      end

      def validate_params
        tracking_validation = Ais::Validations::Tracking.new(tracking_params)
        unless tracking_validation.valid?
          raise(TrackingControllerInvalidParameters, tracking_validation.errors.full_messages.to_sentence)
        end
      end
    end
  end
end
