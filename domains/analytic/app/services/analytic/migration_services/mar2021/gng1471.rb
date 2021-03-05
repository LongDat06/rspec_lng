module Analytic
  module MigrationServices
    module Mar2021
      class Gng1471
        ROW_STATIC_COLUMN_MAPPING = [1, 2, 3, 4, 5]
        ROW_HEADERS = 6

        def call
          mapped_columns
        end

        private
        def mapped_columns
          rows.each.with_index(1) do |row, index|
            next if row.blank?
            next if ROW_HEADERS == index
            next if ROW_STATIC_COLUMN_MAPPING.include?(index)
            column_name = row['K'].parameterize(separator: '_').to_sym

            Analytic::SimChannel.create!(
              standard_name: column_name,
              local_name: row['B'],
              unit: row['C']
            )
          end
        end

        def sim_data_sheet
          @sim_data_sheet ||= Creek::Book.new(dmg_metropolis[:metadata_path])
        end

        def rows
          @rows ||= sim_data_sheet.sheets.first.simple_rows
        end

        def dmg_metropolis #9862487
          {
            metadata_path: "/Users/admin/Desktop/sim/ShipData_9862487_Metadata_r8.xlsx",
            data_path: "/Users/admin/Desktop/sim/IoSData_98624872021011719114459.xlsx"
          }
        end
      end
    end
  end
end
