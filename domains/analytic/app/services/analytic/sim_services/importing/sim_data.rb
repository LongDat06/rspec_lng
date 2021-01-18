module Analytic
  module SimServices
    module Importing
      class SimData
        BATCH_IMPORT_SIZE = 1000

        def initialize(sim_metadata_id:, column_mapping:, sim_file_path:, current_time: Time.current)
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
            @column_mapping.each do |column_name, column_mapped|
              increment_counter
              records << modeling_record(column_name, column_mapped, row, index)
              import_records if reached_batch_import_size? || reached_end_of_file?
            end
          end
        end

        def increment_counter
          self.counter += 1
        end

        def import_records
          Analytic::Sim.collection.insert_many(records)  
          records.clear
        end

        def modeling_record(column_name, column_mapped, row, index)
          row_data = row["#{column_mapped[:index]}#{index}"]

          { 
            column_name => numeric?(column_mapped[:type]) ? row_data.to_f : row_data.to_s,
            sim_metadata_id: @sim_metadata_id,
            created_at: @current_time
          }
        end

        def numeric?(data_type)
          data_type == 'numeric'
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
          @row_count ||= @column_mapping.size
        end

        def reached_end_of_file?
          counter == row_count
        end
      end
    end
  end
end
