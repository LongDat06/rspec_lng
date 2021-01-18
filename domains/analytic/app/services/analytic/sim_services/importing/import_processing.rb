module Analytic
  module SimServices
    module Importing
      class ImportProcessing
        def initialize
        end

        def call
          import_sim_data
        end

        private
        def import_sim_data
          Analytic::SimServices::Importing::SimData.new(
            sim_metadata_id: sim_meta_data_opts.sim_meta_data.id, 
            column_mapping: sim_meta_data_opts.columns_mapping, 
            sim_file_path: sim_data_path
          ).()
        end

        def sim_meta_data_opts
          @sim_meta_data_opts ||= begin
            Analytic::SimServices::Importing::SimMetadata.new(
              input_sim_data: sim_metadata_path,
              sim_data_path: sim_data_path
            ).()
          end
        end

        def sim_metadata_path
          "/Users/admin/Downloads/ShipData_9810020_Metadata_S2332_r3.xlsx"
        end

        def sim_data_path
          "/Users/admin/Downloads/IoSData_98100202020122310420455.xlsx"
        end
      end
    end
  end
end
