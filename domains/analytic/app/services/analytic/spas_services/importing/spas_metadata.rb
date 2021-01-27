module Analytic
  module SpasServices
    module Importing
      class SpasMetadata
        ROW_STATIC_COLUMN_MAPPING = [1, 2, 3, 4, 5]
        ROW_HEADERS = 6

        attr_reader :columns_mapping, :static_sim_meta, :sim_meta_data

        def initialize(input_sim_data:, sim_data_path:)
          @input_sim_data = input_sim_data
          @sim_data_path = sim_data_path
          @static_sim_meta = {}
          @columns_mapping = {
            latitude:  { index: 'D', type: 'numeric' },
            longitude: { index: 'E', type: 'numeric' },
            timestamp: { index: 'C', type: 'string' }
          }
        end

        def call
          mapped_columns
          @sim_meta_data = Analytic::SimMetadata.new(static_sim_meta)
          @sim_meta_data.meta_imported = File.new(@input_sim_data)
          @sim_meta_data.sim_imported = File.new(@sim_data_path)
          @sim_meta_data.created_at = Time.current
          @sim_meta_data.save!
          self
        end

        private
        def mapped_columns
          rows.each.with_index(1) do |row, index|
            next if row.blank?
            next if ROW_HEADERS == index
            if ROW_STATIC_COLUMN_MAPPING.include?(index)
              column_name = row['A'].parameterize(separator: '_').to_sym
              static_sim_meta[column_name] = row['B']
            else
              column_name = row['K'].parameterize(separator: '_').to_sym
              columns_mapping[column_name] = {
                index: UtilityServices::IndexToExcelCol.convert(index),
                type: row['E']
              } 
            end
          end
        end
        
        def sim_data_sheet
          @sim_data_sheet ||= Creek::Book.new(@input_sim_data)
        end

        def rows
          @rows ||= sim_data_sheet.sheets.first.simple_rows
        end
      end
    end
  end
end
