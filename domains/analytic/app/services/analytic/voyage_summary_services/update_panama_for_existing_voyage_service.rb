module Analytic
  module VoyageSummaryServices
    class UpdatePanamaForExistingVoyageService
      include TrackingPacificVoyage
      ARRIVAL = '7:ARV'.freeze
      DEPT = '3:DEP'.freeze

      def call
        voyages = Analytic::VoyageSummary.all
        voyages.each do |voyage|
          Analytic::VoyageSummaryServices::Importing::ImportProcessing.new(imo: voyage.imo,
                                                                          voyage_no: voyage.voyage_no,
                                                                          voyage_leg: voyage.voyage_leg).call
        end
      end
    end
  end
end
