module Analytic
  module V1
    module Voyages
      class RoutesController < BaseController

        def index
          json_response(Analytic::Route.fetch_routes(params[:port_dept], params[:port_arrival]))
        end

        def fetch_first_ports
          json_response(Analytic::Route.fetch_first_ports)
        end

        def fetch_second_ports
          json_response(Analytic::Route.fetch_second_ports(params[:port_dept]))
        end
      end
    end
  end
end
