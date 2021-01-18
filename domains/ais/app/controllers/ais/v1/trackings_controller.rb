module Ais
  module V1
    class TrackingsController < BaseController
      before_action :validate_params, only: [:index]

      def index
        trackings = ExternalServices::Csm::RouteOptimized.new(tracking_params).fetch
        json_response(trackings)
      end

      private
      def tracking_params
        params.permit(:from_time, :to_time, imos: [])
      end

      def validate_params
        tracking_validation = Ais::Validations::Tracking.new(tracking_params)
        unless tracking_validation.valid?
          raise(ExceptionHandler::InvalidParameters, tracking_validation.errors.full_messages.to_sentence)
        end
      end
    end
  end
end
