module Analytic
  module ManagementServices
    class FocService
      attr_reader :imo, :sort_order, :sort_by
      def initialize(imo, sort_by, sort_order)
        @imo = imo
        @sort_by = sort_by
        @sort_order = sort_order
      end

      def call
        search
      end

      private
      def search
        joins_vessel =  "JOIN vessels ON vessels.imo = analytic_focs.imo"
        routes = Analytic::Foc.joins(joins_vessel).joins(:updated_by).select("analytic_focs.id, analytic_focs.imo, speed, laden, 
                                              ballast, analytic_focs.updated_at, analytic_focs.updated_by,
                                              name as vessel_name, users.fullname")
        routes = routes.where("analytic_focs.imo = ?", imo) if imo.present?
        routes.order(sort_by_parser => sort_order_parser)
      end

      def sort_by_parser
        allow_sort_fields = { 'vessel_name' => 'vessel_name', 'speed' => 'speed', 'laden' => 'laden', 'ballast' => 'ballast', 'updated_by' => 'fullname', 'updated_at' => 'updated_at' }
        allow_sort_fields.fetch(@sort_by, 'updated_at')
      end

      def sort_order_parser
        @sort_order == "asc" ? "asc" : "desc"
      end
    end
  end
end
