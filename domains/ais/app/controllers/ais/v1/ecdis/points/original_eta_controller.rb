module Ais
  module V1
    module Ecdis
      class Points::OriginalEtaController < BaseController
        def create
          Ais::Ecdis::UpdateOriginalEta.new(ecdis_points_params).()
          json_response({})
        end

        private

        def ecdis_points_params
          params.permit(ecdis_points: [
            :id,
            :original_eta,
            :ecdis_route_id
          ])
          .require(:ecdis_points)
        end
      end
    end
  end
end
