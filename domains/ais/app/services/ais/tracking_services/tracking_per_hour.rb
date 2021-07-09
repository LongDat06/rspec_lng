module Ais
  module TrackingServices
    class TrackingPerHour
      def initialize(from_time:, to_time:, imo:)
        @from_time = from_time.to_datetime.beginning_of_day
        @to_time = to_time.to_datetime.end_of_day
        @imo = imo
      end

      def get
        trackings
      end

      private
      def trackings
         Ais::Tracking.find_by_sql(
          ActiveRecord::Base.send(:sanitize_sql_array, [
            sql_trackings, 
            from_time: @from_time, 
            to_time: @to_time,
            imo: @imo
          ])
        )
      end

      def sql_trackings
        <<-SQL.strip_heredoc
          SELECT distinct on (date_trunc('hour', last_ais_updated_at)) "trackings".* FROM "trackings" 
          WHERE "trackings"."imo" IN (:imo)
          AND (last_ais_updated_at >= :from_time AND last_ais_updated_at <= :to_time)
          AND "trackings"."is_valid" = 't'
        SQL
      end
    end
  end
end
