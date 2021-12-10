module Analytic
  module ManagementServices
    class RouteService
      attr_reader :route, :port, :sort_by, :sort_order
      def initialize(port, pacific_route, sort_by, sort_order)
        @route = pacific_route.to_s.upcase
        @port = port.to_s.upcase
        @sort_by = sort_by
        @sort_order = sort_order || 'desc'
      end

      def call
        search
      end

      private

      def search
        routes = Analytic::Route.joins(:updated_by).all.select("analytic_routes.id, 
                analytic_routes.port_1, analytic_routes.port_2, analytic_routes.pacific_route,
                analytic_routes.distance, analytic_routes.detail, analytic_routes.updated_at, users.fullname")
        if route.present?
          routes = routes.where("upper(pacific_route) = ?", route)
        end
        if port.present?
          routes = routes.where("upper(port_1) = ? or upper(port_2) = ?", port, port)
        end
        routes.order(sort_by_parser => sort_order)
      end

      def sort_by_parser
        allow_sort_fields = { 'port_1' => 'port_1', 'port_2' => 'port_2', 'pacific_route' => 'pacific_route', 'distance' => 'distance', 'updated_by' => 'fullname'}
        allow_sort_fields.fetch(@sort_by, 'updated_at')
      end
    end
  end
end
