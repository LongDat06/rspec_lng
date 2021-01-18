module Ais
  module V1
    class PlanRoutesController < BaseController
      def index
        voyage_tracks = ExternalServices::Csm::VoyageTrack.new(tracking_params).fetch
        json_response(voyage_tracks)
      end

      private
      def tracking_params
        {
          imos: params[:imos]
        }
      end
    end
  end
end
