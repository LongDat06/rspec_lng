module Analytic
  module ManagementServices
    module Exporting
      class Route < Base
        attr_reader :port_id, :master_route_id, :sort_by, :sort_order
        def initialize(port_id, master_route_id, sort_by, sort_order)
          @port_id = port_id
          @master_route_id = master_route_id
          @sort_by = sort_by
          @sort_order = sort_order
        end
        def header
          ['Port Name 1', 'Port Name 2', 'Route', 'Estimated Distance (NM)', 'Route Detail']
        end

        def rows
          routes = Analytic::ManagementServices::RouteService.new(port_id, master_route_id, sort_by, sort_order).()
          routes.map {|route| [route["port_1_name"], route["port_2_name"], route["route_name"], route["distance"], route["detail"]]}
        end

        def file_name
          "exported_route_#{Time.current.utc.strftime('%FT-%H-%M-%S')}.xlsx"
        end
      end
    end
  end
end
