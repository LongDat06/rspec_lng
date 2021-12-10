module Analytic
  module V1
    module Management
      class MasterRoutesController < BaseController
        before_action :set_route, only: [:destroy, :update]
        def index
          authorize Analytic::MasterRoute
          routes = Analytic::MasterRoute.all.order(:name)
          pagy, routes = pagy(routes, items: PER_PAGE)
          routes_json = Analytic::V1::Management::MasterRouteSerializer.new(routes).serializable_hash
          pagy_headers_merge(pagy)
          json_response(routes_json)
        end

        def create
          authorize Analytic::MasterRoute
          Analytic::MasterRoute.create! create_params
          json_response({})
        end

        def update
          @route.update! update_params
          json_response({})
        end

        def destroy
          @route.destroy!
          json_response({})
        end

        def fetch_autocomplete_routes
          routes = Analytic::MasterRoute.autocomplete_routes(params[:route])
          json_response(routes)
        end

        private
        def set_route
          @route = Analytic::MasterRoute.find_by_id(params[:id])
          not_found_record unless @route.present?
          authorize @route
        end

        def create_params
          params.permit(:name).merge!(created_by_id: current_user.id, updated_by_id: current_user.id)
        end

        def update_params
          params.permit(:name).merge!(updated_by_id: current_user.id)
        end
      end
    end
  end
end
