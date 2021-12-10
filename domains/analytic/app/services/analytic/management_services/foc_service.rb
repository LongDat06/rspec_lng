module Analytic
  module ManagementServices
    class FocService
      attr_reader :imo, :sort_order, :sort_by
      def initialize(imo, sort_by, sort_order)
        @imo = imo
        @sort_by = sort_by
        @sort_order = sort_order || 'asc'
      end

      def call
        search
      end

      private
      def search
        Analytic::Vessel.joins(focs: :updated_by).select("analytic_focs.id, analytic_focs.imo, speed, laden, 
                                              ballast, analytic_focs.updated_at, analytic_focs.updated_by,
                                              name as vessel_name, users.fullname").
                        where("analytic_focs.imo = ?", imo).
                        order(sort_by_parser => sort_order)
      end

      def sort_by_parser
        allow_sort_fields = { 'speed' => 'speed', 'laden' => 'laden', 'ballast' => 'ballast', 'updated_by' => 'fullname', 'updated_at' => 'updated_at' }
        allow_sort_fields.fetch(@sort_by, 'speed')
      end
    end
  end
end
