module Ais
  module V1
    class PlanRoutesController < BaseController
      def index
        voyage_tracks = ExternalServices::Csm::VoyageTrack.new(tracking_params).fetch
        json_response(voyage_tracks)
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
