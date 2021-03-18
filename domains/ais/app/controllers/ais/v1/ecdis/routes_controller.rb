module Ais
  module V1
    module Ecdis
      class RoutesController < BaseController
        def index
          routes = Ais::EcdisRoute
                    .imo(filter_params[:imo])
                    .of_month(filter_params[:time]&.to_datetime)
                    .order(:created_at)
          routes_json = Ais::V1::Ecdis::RoutesSerializer.new(routes).serializable_hash
          json_response(routes_json)
        end

        def point_routes
          routes = Ais::EcdisRoute.includes(:ecdis_points).where(id: filter_params[:ecdis_route_ids])
          routes_json = Ais::V1::Ecdis::PointRoutesSerializer.new(routes).serializable_hash
          json_response(routes_json)
        end

        private
        def filter_params
          params.permit(:imo, :time, ecdis_route_ids: [])
        end
      end
    end
  end
end
