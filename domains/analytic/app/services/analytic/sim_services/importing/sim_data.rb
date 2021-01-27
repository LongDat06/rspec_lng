module Analytic
  module SimServices
    module Importing
      class SimData
        BATCH_IMPORT_SIZE = 10

        def initialize(imo_no:, sim_metadata_id:, column_mapping:, sim_file_path:, current_time: Time.current)
          @imo_no = imo_no
          @sim_metadata_id = sim_metadata_id
          @column_mapping = column_mapping
          @current_time = current_time
          @sim_file_path = sim_file_path
          @records = []
          @counter = 0
        end

        def call
          processing_rows
        end

        private
        attr_reader :records
        attr_accessor :counter

        def processing_rows
          rows.each.with_index(1) do |row, index|
            increment_counter
            records << modeling_record(row, index)
            import_records if reached_batch_import_size? || reached_end_of_file?
          end
        end

        def increment_counter
          self.counter += 1
        end

        def import_records
          Analytic::Sim.collection.insert_many(records)  
          records.clear
        end

        def modeling_sim_spec(row, index)
          {}.tap do |hashing|
            @column_mapping.each do |column_name, column_mapped|
              row_data = row["#{column_mapped[:index]}#{index}"]
              next if row_data.blank?
              hashing[column_name] = if numeric?(column_mapped[:type])
                row_data.to_f
              elsif datetime?(column_mapped[:type])
                row_data.to_datetime.utc
              else
                row_data.to_s
              end
            end
          end
        end

        def modeling_record(row, index)
          {
            imo_no: @imo_no,
            sim_metadata_id: @sim_metadata_id,
            spec: modeling_sim_spec(row, index)
          }
        end

        def numeric?(data_type)
          data_type == 'numeric'
        end

        def datetime?(data_type)
          data_type == 'datetime'
        end

        def rows
          @rows ||= sim_data_sheet.sheets.first.rows
        end

        def sim_data_sheet
          @sim_data_sheet ||= Creek::Book.new(@sim_file_path)
        end

        def reached_batch_import_size?
          (counter % BATCH_IMPORT_SIZE).zero?
        end

        def row_count
          @row_count ||= rows.count
        end

        def reached_end_of_file?
          counter == row_count
        end

        def set_value(value)
          value + Random.rand(99)
        end
      end
    end
  end
end
