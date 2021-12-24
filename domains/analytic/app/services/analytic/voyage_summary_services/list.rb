module Analytic
  module VoyageSummaryServices
    class ListError < StandardError; end

    class List
      def initialize(params:)
        @imo = params[:imo]
        @from_time = params[:from_time]
        @to_time = params[:to_time]
        @port_dept = params[:port_dept]
        @port_arrival = params[:port_arrival]
        @voyage_no = params[:voyage_no]
        @voyage_leg = params[:voyage_leg]
        @sort_by = params[:sort_by]
        @sort_order = params[:sort_order]
      end

      def fetch
        voyage_summaries
      end

      private

      def voyage_summaries
        @voyage_summaries ||= begin
          relation = Analytic::VoyageSummary.joins_edq_results.joins(:vessel).select(select_fields)
          relation = relation.where(imo: @imo) if @imo.present?
          relation = relation.where(port_dept: @port_dept) if @port_dept.present?
          relation = relation.where(port_arrival: @port_arrival) if @port_arrival.present?
          if @from_time.present? && @to_time.present?
            relation = relation.where('(atd_lt, ata_lt) OVERLAPS (?,?)', @from_time.to_datetime.beginning_of_day,
                                      @to_time.to_datetime.end_of_day)
          end
          relation = relation.where(voyage_no: @voyage_no) if @voyage_no.present?
          relation = relation.where(voyage_leg: voyage_leg_field(@voyage_leg)) if @voyage_leg.present?
          relation.order(sort_by_parser => sort_order_parser)
        end
      end

      def sort_by_parser
        allow_sort_fields = {
          'vessel_name' => 'vessels.name',
          'voyage_no' => 'voyage_no',
          'voyage_leg' => 'voyage_leg',
          'voyage_name' => 'concat(voyage_no, voyage_leg)',
          'port_dept' => 'port_dept',
          'atd_lt' => 'atd_lt',
          'atd_utc' => 'atd_utc',
          'port_arrival' => 'port_arrival',
          'ata_lt' => 'ata_lt',
          'ata_utc' => 'ata_utc',
          'duration' => 'duration',
          'distance' => 'distance',
          'average_speed' => 'average_speed',
          'cargo_volume_at_port_of_arrival' => 'cargo_volume_at_port_of_arrival',
          'lng_consumption' => 'lng_consumption',
          'mgo_consumption' => 'mgo_consumption',
          'average_boil_off_rate' => 'average_boil_off_rate',
          'actual_heel' => 'actual_heel',
          'adq' => 'adq',
          'estimated_heel' => estimated_heel_clause,
          'estimated_edq' => estimated_edq_clause
        }
        Arel.sql(allow_sort_fields.fetch(@sort_by, 'voyage_no'))
      end

      def sort_order_parser
        @sort_order == 'asc' ? 'asc' : 'desc'
      end

      def voyage_leg_field(type)
        allows_field = %w[L B]
        return type.upcase if allows_field.include?(type.upcase)

        raise ListError, "Unknown voyage leg: #{type}"
      end

      def select_fields
        <<~SQL
          analytic_voyage_summaries.*,
          concat(voyage_no, voyage_leg) voyage_name,
          vessels.name vessel_name,
          #{estimated_heel_clause} estimated_heel,
          #{estimated_edq_clause} estimated_edq
        SQL
      end

      def estimated_heel_clause
        <<~SQL
          CASE WHEN analytic_voyage_summaries.voyage_leg = 'B' THEN analytic_edq_results.heel ELSE NULL END
        SQL
      end

      def estimated_edq_clause
        <<-SQL
          CASE WHEN analytic_voyage_summaries.voyage_leg = 'L' THEN analytic_edq_results.edq ELSE NULL END
        SQL
      end
    end
  end
end
