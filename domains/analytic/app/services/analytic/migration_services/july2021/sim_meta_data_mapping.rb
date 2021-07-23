module Analytic
  module MigrationServices
    module July2021
      class SimMetaDataMapping
        ROW_STATIC_COLUMN_MAPPING = [1, 2, 3, 4, 5]
        ROW_HEADERS = 6
        DEFAULT_TYPE = 'string'.freeze

        attr_reader :columns_mapping, :static_sim_meta, :sim_meta_data

        def initialize(input_sim_data:, sim_data_path:)
          @input_sim_data = input_sim_data
          @sim_data_path = sim_data_path
          @static_sim_meta = {}
          @columns_mapping = {
            ts: { index: 0, type: 'datetime' }
          }
        end

        def call
          mapped_columns
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
                index: index - 6,
                type: row['E'].present? ? row['E'].parameterize : DEFAULT_TYPE
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
