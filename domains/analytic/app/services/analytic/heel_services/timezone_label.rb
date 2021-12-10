module Analytic
  module HeelServices
    class TimezoneLabel
      TimeZoneLabelResult = Struct.new(:label, :time_zone, :time_utc)

      def initialize(time:, port_id: nil, time_zone: nil)
        @time = time
        @port_id = port_id
        @time_zone = time_zone
      end

      def call
        TimeZoneLabelResult.new(label, fetch_time_zone, time_utc)
      end

      private
      def fetch_time_zone
        return fetch_port.time_zone if @port_id.present?

        return @time_zone
      end

      def label
        return "" if fetch_time_zone.blank?

        label = "#{fetch_time_zone}, UTC #{time_in_zone.formatted_offset}"
        label << " (DST)" if time_in_zone.dst?
        label
      end

      def time_in_zone
        @time_in_zone ||= begin
          if @time.is_a? Time
            @time.asctime.in_time_zone(fetch_time_zone)
          else
            Time.find_zone(fetch_time_zone).parse(@time)
          end
        end
      end

      def time_utc
        time_in_zone.utc
      end

      def fetch_port
        @fetch_port ||= Analytic::MasterPort.find(@port_id)
      end
    end
  end
end
