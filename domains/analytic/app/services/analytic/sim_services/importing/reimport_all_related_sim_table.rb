module Analytic
  module SimServices
    module Importing
      class ReimportAllRelatedSimTable
        include ImportOldestSimData
        include CleanShipdcData
        attr_reader :imo, :data_type
        def initialize(imo, data_type)
          @imo = imo
          @data_type = data_type
        end
        def call
          clear_old_related_sim_table(imo)
          oldest_sim_date = get_oldest_sim_date(imo, data_type)
          if oldest_sim_date.present?
            create_channels
            import_sim_from_past(imo, oldest_sim_date, data_type)
          end
        end

        private
        def create_channels
          Analytic::SimJob::ImportChannelJob.perform_later(imo)
        end
      end
    end
  end
end
