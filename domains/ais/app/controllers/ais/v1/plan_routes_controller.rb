module Ais
  module V1
    class PlanRoutesController < BaseController
      def index
        authorize Ais::Vessel, policy_class: Ais::PlanRoutesPolicy
        voyage_tracks = ExternalServices::Csm::VoyageTrack.new(tracking_params).fetch
        json_response(voyage_tracks)
      end

      private
      def tracking_params
        params.permit(:from_time, :to_time, imos: [])
      end
    end
  end
end
