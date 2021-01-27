module Analytic
  module SimServices
    module Importing
      class ImportProcessing

        def initialize(sim)
          @sim_metadata_path = sim[:metadata_path]
          @sim_data_path = sim[:data_path]
        end

        def call
          import_sim_data
        end

        private

        attr_reader :sim_metadata_path, :sim_data_path

        def import_sim_data
          Analytic::SimServices::Importing::SimData.new(
            imo_no: sim_meta_data_opts.sim_meta_data.imo_no, 
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
      end
    end
  end
end
