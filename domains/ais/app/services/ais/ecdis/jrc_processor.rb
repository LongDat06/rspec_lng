module Ais
  module Ecdis
    class JrcProcessor
      JRC_MAPPING = Ais::Ecdis::MappingColumn::JRC
      POINT_ROW_FROM_INDEX = 3

      def initialize(received_at:, filepath:, filename:, vessel:)
        @filepath = filepath
        @filename = filename
        @received_at = received_at.to_datetime.utc
        @vessel = vessel
      end

      def call 
        processing_row
      end

      private

      def data_rows
        @data_rows ||= begin
          csv_rows = []
          CSV.foreach(@filepath, headers: true, col_sep: ',') do |row|
            csv_rows << row
          end

          csv_rows
        end
      end

      def route_record
        @route_record ||= Ais::EcdisRoute.new(
          vessel: @vessel,
          format_file: 'jrc',
          file_name: @filename,
          received_at: @received_at
        )
      end

      def point_rows
        @point_rows = data_rows.select.with_index { |_, i| i > POINT_ROW_FROM_INDEX }
      end

      def point_modeling(row)
        Ais::EcdisPoint.new(
          ecdis_route: route_record,
          name: row[JRC_MAPPING[:NAME]] || ' ',
          lat: Ais::UtilityServices::LatLonConverter.dd_calculator(row[JRC_MAPPING[:LAT]], row[JRC_MAPPING[:LAT_D]], row[JRC_MAPPING[:LAT_C]]),
          lon: Ais::UtilityServices::LatLonConverter.dd_calculator(row[JRC_MAPPING[:LON]], row[JRC_MAPPING[:LON_D]], row[JRC_MAPPING[:LON_C]]),
          leg_type: row[JRC_MAPPING[:SAIL]].blank? ? nil : row[JRC_MAPPING[:SAIL]],
          turn_radius: row[JRC_MAPPING[:TURN_RAD]]
        )
      end

      def point_records
        @point_records = begin
          built_records = []
        
          point_rows.each do |row|
            built_records << point_modeling(row)
          end

          built_records
        end
      end

      def processing_row
        Ais::EcdisRoute.transaction do
          route_record.save!
          Ais::EcdisPoint.import!(point_records)
        end
      end
    end
  end
end
