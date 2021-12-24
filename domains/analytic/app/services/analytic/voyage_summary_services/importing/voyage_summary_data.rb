module Analytic
  module VoyageSummaryServices
    module Importing
      class VoyageSummaryData

        def initialize(spas_ids)
          @spas_ids = spas_ids
        end

        def call
          return if @spas_ids.blank?

          voyage_data.each do |item|
            Analytic::VoyageSummaryServices::Importing::ImportProcessing.new(imo: item.imo,
                                                                             voyage_no: item.voyage_no,
                                                                             voyage_leg: item.voyage_leg).()
          end
        end

        private
        def voyage_data
          Analytic::VoyageSummaryServices::ProvideVoyageData.new(@spas_ids).call
        end

      end
    end
  end
end
