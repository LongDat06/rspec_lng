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
        @pacific_voyage = params[:pacific_voyage]
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

          if @port_dept.present?
            port_dept_query = @port_dept == "-" ? "#{apply_port_dept} IS NULL" : ["#{apply_port_dept} = ?", @port_dept]
            relation = relation.where(port_dept_query)
          end

          if @port_arrival.present?
            port_arrival_query = @port_arrival == "-" ? "#{apply_port_arrival} IS NULL" : ["#{apply_port_arrival} = ?", @port_arrival]
            relation = relation.where(port_arrival_query)
          end

          if @from_time.present? && @to_time.present?
            relation = relation.where("(#{apply_atd_lt}, #{apply_ata_lt}) OVERLAPS (?,?)", @from_time.to_datetime.beginning_of_day,
                                      @to_time.to_datetime.end_of_day)
          end
          relation = relation.where(voyage_no: @voyage_no) if @voyage_no.present?
          relation = relation.where(voyage_leg: voyage_leg_field(@voyage_leg)) if @voyage_leg.present?
          relation = relation.where(pacific_voyage: @pacific_voyage) if @pacific_voyage.present?

          order_params = {sort_by_parser => sort_order_parser}
          order_params[:leg_id] ||= :asc
          relation.order(order_params)
        end
      end

      def sort_by_parser
        allow_sort_fields = {
          'vessel_name' => 'vessels.name',
          'voyage_no' => 'voyage_no',
          'voyage_leg' => 'voyage_leg',
          'leg_id' => 'leg_id',
          'voyage_name' => 'concat(voyage_no, voyage_leg)',
          'apply_port_dept' => apply_port_dept,
          'apply_atd_lt' => apply_atd_lt,
          'apply_port_arrival' => apply_port_arrival,
          'apply_ata_lt' => apply_ata_lt,
          'apply_duration' => apply_duration,
          'apply_distance' => apply_distance,
          'apply_average_speed' => apply_average_speed,
          'cargo_volume_at_port_of_arrival' => 'cargo_volume_at_port_of_arrival',
          'lng_consumption' => 'lng_consumption',
          'mgo_consumption' => 'mgo_consumption',
          'average_boil_off_rate' => 'average_boil_off_rate',
          'actual_heel' => 'actual_heel',
          'adq' => 'adq',
          'estimated_heel' => estimated_heel_clause,
          'pacific_voyage' => 'pacific_voyage',
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
        <<~SQL.squish
          analytic_voyage_summaries.*,
          #{apply_port_dept}                            apply_port_dept,
          #{apply_port_arrival}                         apply_port_arrival,
          #{apply_atd_lt}                               apply_atd_lt,
          #{apply_ata_lt}                               apply_ata_lt,
          COALESCE(manual_atd_utc, atd_utc)             apply_atd_utc,
          COALESCE(manual_ata_utc, ata_utc)             apply_ata_utc,
          #{apply_distance}                             apply_distance,
          #{apply_duration}                             apply_duration,
          #{apply_average_speed}                        apply_average_speed,
          concat(voyage_no, voyage_leg)                 voyage_name,
          vessels.name                                  vessel_name,
          #{estimated_heel_clause}                      estimated_heel,
          #{estimated_edq_clause}                       estimated_edq
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

      def apply_port_dept
        <<~SQL
          COALESCE(manual_port_dept, port_dept)
        SQL
      end

      def apply_port_arrival
        <<~SQL
          COALESCE(manual_port_arrival, port_arrival)
        SQL
      end

      def apply_atd_lt
        <<~SQL
          COALESCE(manual_atd_lt, atd_lt)
        SQL
      end

      def apply_ata_lt
        <<~SQL
          COALESCE(manual_ata_lt, ata_lt)
        SQL
      end

      def apply_distance
        <<~SQL
          COALESCE(manual_distance, distance)
        SQL
      end

      def apply_duration
        <<~SQL
          COALESCE(manual_duration, duration)
        SQL
      end

      def apply_average_speed
        <<~SQL
          COALESCE(manual_average_speed, average_speed)
        SQL
      end
    end
  end
end
