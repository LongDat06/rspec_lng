module Analytic
  module VoyageSummaryJob
    class ImportingJob < ApplicationJob
      queue_as :importing_job

      def perform(imo = nil, voyage_no = nil, voyage_leg = nil)
        imos = [imo]
        imos = target_imos if imo.nil?
        imos.each do |imo_no|
          Analytic::VoyageSummaryServices::Importing::ImportProcessing.new(imo: imo_no,
                                                                           voyage_no: voyage_no,
                                                                           voyage_leg: voyage_leg).call
        end
      end

      private
      def target_imos
        @target_imos ||= Ais::Vessel.target(true).pluck(:imo)
      end

    end
  end
end
