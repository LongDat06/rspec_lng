module Analytic
  module V1
    module Management
      class RoutesController < BaseController
        before_action :set_route, only: [:update, :destroy]
        before_action :add_authorize, only: [:index, :create, :import, :fetch_invalid_record_file, :export]

        def index
          routes = Analytic::ManagementServices::RouteService.new(params[:port_id], params[:master_route_id], params[:sort_by], params[:sort_order]).()
          pagy, routes = pagy(routes, items: PER_PAGE)

          routes_json = Analytic::V1::Management::RouteSerializer.new(routes).serializable_hash
          pagy_headers_merge(pagy)
          json_response(routes_json)
        end

        def create
          Analytic::Route.create! create_params
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
          job = Analytic::ManagementJob::ExportingRouteJob.set(wait: 3.seconds).perform_later(params[:port_id], params[:master_route_id], params[:sort_by], params[:sort_order])
          json_response({job_id: job&.job_id})
        end

        private
        def set_route
          @route = Analytic::Route.find_by_id(params[:id])
          not_found_record unless @route.present?
          authorize @route
        end

        def add_authorize
          authorize Analytic::Route
        end

        def create_params
          ports = [params[:port_1].to_s.upcase, params[:port_2].to_s.upcase].sort
          port_1_id, port_2_id = Analytic::MasterPort.sort_port(ports)
          route_params = params.permit(:distance, :detail)
          route_params.merge!(temp_route_name: params[:route_name], port_1_id: port_1_id, port_2_id: port_2_id, temp_port_name_1: ports.first, temp_port_name_2: ports.last, updated_by: current_user, created_by_id: current_user.id)
        end

        def update_params
          params.permit(:distance, :detail).merge!(updated_by: current_user)
        end
      end
    end
  end
end
