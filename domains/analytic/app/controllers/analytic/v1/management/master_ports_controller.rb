module Analytic
  module V1
    module Management
      class MasterPortsController < BaseController
        before_action :set_port, only: [:update, :destroy]
        before_action :add_authorize, only: [:index, :create]

        def index
          ports = Analytic::ManagementServices::MasterPortService.new(params[:sort_by], params[:sort_order]).()
          
          pagy, ports = pagy(ports, items: PER_PAGE)
          ports_json = Analytic::V1::Management::MasterPortSerializer.new(ports).serializable_hash
          pagy_headers_merge(pagy)
          json_response(ports_json)
        end

        def create
          Analytic::MasterPort.create! port_params
          json_response({})
        end

        def update
          @port.update! update_params
          json_response({})
        end

        def destroy
          @port.destroy!
          json_response({})
        end

        def fetch_autocomplete_ports
          port_param = params[:port_1] || params[:port_2]
          ports = Analytic::MasterPort.autocomplete_ports(port_param)
          json_response(ports)
        end

        private
        def set_port
          @port = Analytic::MasterPort.find_by_id(params[:id])
          not_found_record unless @port.present?
          authorize @port
        end

        def add_authorize
          authorize Analytic::MasterPort
        end

        def port_params
          params.permit(:name, :country_code, :time_zone).merge!(created_by_id: current_user.id, updated_by: current_user)
        end

        def update_params
          params.permit(:name, :country_code, :time_zone).merge!(updated_by: current_user)
        end
      end
    end
  end
end
