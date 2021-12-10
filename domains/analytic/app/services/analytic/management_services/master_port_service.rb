module Analytic
  module ManagementServices
    class MasterPortService
      attr_reader :sort_order, :sort_by
      def initialize(sort_by, sort_order)
        @sort_by = sort_by
        @sort_order = sort_order
      end

      def call
        search
      end

      private
      def search
        Analytic::MasterPort.joins(:updated_by).select("analytic_master_ports.id, analytic_master_ports.name, 
                                                       analytic_master_ports.updated_at, analytic_master_ports.country_code,
                                                       analytic_master_ports.time_zone, users.fullname as fullname").
                              order(sort_by_parser => sort_order_parser)
      end

      def sort_by_parser
        allow_sort_fields = { 'name' => 'name', 'country' => 'country_code', 'time_zone_name' => 'time_zone', 'updated_by' => 'fullname', 'updated_at' => 'updated_at' }
        allow_sort_fields.fetch(@sort_by, 'name')
      end

      def sort_order_parser
        @sort_order == "desc" ? "desc" : "asc"
      end
    end
  end
end
