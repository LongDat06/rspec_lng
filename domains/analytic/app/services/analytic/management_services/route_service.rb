module Analytic
  module ManagementServices
    class RouteService
      attr_reader :master_route_id, :port_id, :sort_by, :sort_order
      def initialize(port_id, master_route_id, sort_by, sort_order)
        @master_route_id = master_route_id
        @port_id = port_id
        @sort_by = sort_by
        @sort_order = sort_order
      end

      def call
        search
      end

      private

      def search
        select_fields  = "analytic_routes.*, port_1.name as port_1_name, port_2.name as port_2_name, users.fullname, analytic_master_routes.name as route_name"
        join_port_1_clause = "JOIN analytic_master_ports port_1 ON port_1.id = analytic_routes.port_1_id"
        join_port_2_clause = "JOIN analytic_master_ports port_2 ON port_2.id = analytic_routes.port_2_id"
        routes = Analytic::Route.select(select_fields).joins(:updated_by).joins(:master_route).joins(join_port_1_clause).joins(join_port_2_clause)
        routes = routes.where("analytic_routes.port_1_id = :port_id OR analytic_routes.port_2_id = :port_id", { port_id: @port_id } ) if @port_id.present?
        routes = routes.where("analytic_routes.master_route_id = ?", @master_route_id ) if @master_route_id.present?
        routes.order( sort_by_parser => sort_order_parser)
      end

      def sort_by_parser
        allow_sort_fields = { 'port_1_name' => 'port_1_name', 'port_2_name' => 'port_2_name', 'route_name' => 'route_name', 'distance' => 'distance', 'detail' => 'detail', 'updated_by' => 'fullname'}
        allow_sort_fields.fetch(@sort_by, 'updated_at')
      end

      def sort_order_parser
        @sort_order == "asc" ? "asc" : "desc"
      end
    end
  end
end
