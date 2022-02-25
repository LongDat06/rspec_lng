module Analytic
  module VoyageSummaryServices
    class UpdateDataForExistedVoyages
      include TrackingPacificVoyage
      ARRIVAL = '7:ARV'.freeze
      DEPT = '3:DEP'.freeze
      def call
        updating_for_some_fields
      end

      private
      def updating_for_some_fields
        voyages = Analytic::VoyageSummary.all
        voyages.each do |voyage|
          pacific_voyage = fetching_pacific_voyage voyage.imo, voyage.apply_atd_utc, voyage.apply_ata_utc
          voyage.update(pacific_voyage: pacific_voyage)
        end
      end
    end
  end
end
