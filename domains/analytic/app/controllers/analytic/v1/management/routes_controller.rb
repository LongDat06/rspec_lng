module Analytic
  module V1
    module Management
      class RoutesController < BaseController
        before_action :set_route, only: [:update, :destroy, :show]
        before_action :add_authorize, only: [:index, :create, :import, :fetch_invalid_record_file, :export]

        def index
          routes = Analytic::ManagementServices::RouteService.new(params[:port], params[:pacific_route], params[:sort_by], params[:sort_order]).()
          pagy, routes = pagy(routes, items: PER_PAGE)
          routes_json = Analytic::V1::Management::RouteSerializer.new(routes).serializable_hash
          pagy_headers_merge(pagy)
          json_response(routes_json)
        end

        def create
          Analytic::Route.create! create_params
          json_response({})
        end

        def show
          json_response(Analytic::V1::Management::RouteSerializer.new(@route))
        end

        def update
          @route.update! update_params
          json_response({})
        end

        def destroy
          @route.destroy!
          json_response({})
        end

        def import
          metadata = uploader
          Analytic::ManagementJob::ImportingRouteJob.perform_later(metadata, current_user.id)
          json_response({})
        end

        def fetch_invalid_record_file
          url = Analytic::ReportFile.fetch_report_url(Analytic::ReportFile::ROUTE)
          json_response({url: url})
        end

        def export
          Analytic::ManagementJob::ExportingRouteJob.perform_later(current_user.id, params[:port], params[:pacific_route], params[:sort_by], params[:sort_order])
          json_response({})
        end

        private
        def set_route
          @route = Analytic::Route.find(params[:id])
          authorize @route
        end

        def add_authorize
          authorize Analytic::Route
        end

        def create_params
          route_params = params.permit(:port_1, :port_2, :pacific_route, :distance)
          route_params.merge!(updated_by: current_user, created_by: current_user)
        end

        def update_params
          params.permit(:distance).merge!(updated_by: current_user)
        end
      end
    end
  end
end
