module Analytic
  module ManagementServices
    module Exporting
      class Route < Base
        attr_reader :port, :pacific_route, :sort_by, :sort_order
        def initialize(port, pacific_route, sort_by, sort_order)
          @port = port
          @pacific_route = pacific_route
          @sort_by = sort_by
          @sort_order = sort_order
        end
        def header
          ['Port Name 1', 'Port Name 2', 'Pacific Route', 'Estimated Distance (NM)', 'Route Detail']
        end

        def rows
          routes = Analytic::ManagementServices::RouteService.new(port, pacific_route, sort_by, sort_order).()
          routes.pluck(:port_1, :port_2, :pacific_route, :distance, :detail)
        end

        def file_name
          "exported_route_#{Time.current.utc.strftime('%FT-%H-%M-%S')}.xlsx"
        end
      end
    end
  end
end
