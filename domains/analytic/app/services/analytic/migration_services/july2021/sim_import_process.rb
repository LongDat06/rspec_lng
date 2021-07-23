module Analytic
  module MigrationServices
    module July2021
      class SimImportProcess

        def initialize(sim, imo)
          @sim_metadata_path = sim[:metadata_path]
          @sim_data_path = sim[:data_path]
          @imo = imo
        end

        def call
          import_sim_data
        end

        private

        attr_reader :sim_metadata_path, :sim_data_path

        def import_sim_data
          Analytic::MigrationServices::July2021::SimImportForAis.new(
            imo_no: @imo, 
            column_mapping: sim_meta_data_opts.columns_mapping, 
            sim_file_path: sim_data_path
          ).()
        end

        def sim_meta_data_opts
          @sim_meta_data_opts ||= begin
            Analytic::MigrationServices::July2021::SimMetaDataMapping.new(
              input_sim_data: sim_metadata_path,
              sim_data_path: sim_data_path
            ).()
          end
        end
      end
    end
  end
end