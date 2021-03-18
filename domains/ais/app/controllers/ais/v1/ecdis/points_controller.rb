module Ais
  module V1
    module Ecdis
      class PointsController < BaseController
        def index
          points = Ais::EcdisPoint.routes(filter_params[:ecdis_route_ids])
          points_json = Ais::V1::Ecdis::PointsSerializer.new(points).serializable_hash
          json_response(points_json)
        end

        private
        def filter_params
          params.permit(:ecdis_route_ids, :from_time, :to_time)
        end
      end
    end
  end
end
