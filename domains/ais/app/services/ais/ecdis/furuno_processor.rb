module Ais
  module Ecdis
    class FurunoProcessor
      FURUNO_MAPPING = Ais::Ecdis::MappingColumn::FURUNO
      FIRST_ROW_DATA_INDEX = 0
      ETA_ETD_ROW_INDEX = 2
      POINT_ROW_FROM_INDEX = 4

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
          CSV.foreach(@filepath, col_sep: '\t') do |row|
            csv_rows << row
          end

          csv_rows
        end
      end

      def process_data_rows
        @process_data_rows ||= begin
          result = []
          return result if data_rows.nil? || data_rows.empty?

          header = data_rows.shift
          header.map!{ |x| x.downcase.to_sym }
          
          data_rows.each do |row|
            result << row[0].split(/\t/)
          end

          result
        end
      end

      def etd
        @etd ||= begin
          date = process_data_rows[ETA_ETD_ROW_INDEX][0..2].join("-")
          time = process_data_rows[ETA_ETD_ROW_INDEX][3..4].join(":")
          
          [date, time].join(' ')
        end
      end

      def eta
        @eta ||= begin
          date = process_data_rows[ETA_ETD_ROW_INDEX][5..7].join("-")
          time = process_data_rows[ETA_ETD_ROW_INDEX][8..9].join(":")
          
          [date, time].join(' ')
        end
      end

      def max_power
        @max_power = process_data_rows[FIRST_ROW_DATA_INDEX][0]
      end

      def speed
        @speed = process_data_rows[FIRST_ROW_DATA_INDEX][1]
      end

      def etd_wpno
        @etd_wpno = process_data_rows[FIRST_ROW_DATA_INDEX][2]
      end

      def eta_wpno
        @etd_wpno = process_data_rows[FIRST_ROW_DATA_INDEX][3]
      end

      def optimized
        @optimized = process_data_rows[FIRST_ROW_DATA_INDEX][4]
      end

      def budget
        @budget = process_data_rows[FIRST_ROW_DATA_INDEX][5]
      end

      def route_record
        @route_record ||= Ais::EcdisRoute.new(
          vessel: @vessel,
          format_file: 'furuno',
          file_name: @filename,
          etd: etd,
          eta: eta,
          max_power: max_power,
          speed: speed,
          etd_wpno: etd_wpno,
          eta_wpno: eta_wpno,
          optimized: optimized,
          budget: budget,
          received_at: @received_at
        )
      end

      def point_rows
        @point_rows = process_data_rows.select.with_index { |_, i| i > POINT_ROW_FROM_INDEX }
      end

      def leg_type_to_enum(leg)
        leg == 'RHUMBLINE' ? 'RL' : 'GC'
      end

      def point_modeling(row)
        Ais::EcdisPoint.new(
          ecdis_route: route_record,
          name: row[FURUNO_MAPPING[:NAME]],
          lat: Ais::UtilityServices::LatLonConverter.ddm_to_dd(row[FURUNO_MAPPING[:LAT]]),
          lon: Ais::UtilityServices::LatLonConverter.ddm_to_dd(row[FURUNO_MAPPING[:LON]]),
          leg_type: leg_type_to_enum(row[FURUNO_MAPPING[:LEG_TYPE]]),
          turn_radius: row[FURUNO_MAPPING[:TURN_RADIUS]],
          chn_limit: row[FURUNO_MAPPING[:CHN_LIMIT]],
          planned_speed: row[FURUNO_MAPPING[:PLANNED_SPEED]],
          speed_min: row[FURUNO_MAPPING[:SPEED_MIN]],
          speed_max: row[FURUNO_MAPPING[:SPEED_MAX]],
          course: row[FURUNO_MAPPING[:COURSE]],
          length: row[FURUNO_MAPPING[:LENGTH]],
          do_plan: row[FURUNO_MAPPING[:DO_PLAN]],
          do_left: row[FURUNO_MAPPING[:DO_LEFT]],
          hfo_plan: row[FURUNO_MAPPING[:HFO_PLAN]],
          hfo_left: row[FURUNO_MAPPING[:HFO_LEFT]]
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
