module Ais
  module V1
    module Ecdis
      class EcdisRoutesControllerInvalidParameters < ActionController::BadRequest; end
      class RoutesController < BaseController
        before_action :validate_params, only: [:point_routes]

        def index
          routes = Ais::EcdisRoute
                    .imo(filter_params[:imo])
                    .of_month(filter_params[:time]&.to_datetime)
                    .order([received_at: :desc, file_name: :desc])
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

        def validate_params
          filter_params_validation = Ais::Validations::Ecdis::EcdisRoutes.new(filter_params)
          unless filter_params_validation.valid?
            raise(
              EcdisRoutesControllerInvalidParameters, 
              filter_params_validation.errors.full_messages.to_sentence
            )
          end
        end
      end
    end
  end
end
