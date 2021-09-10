module Analytic
  module SpasJob
    class RepDataVerifyJob < ApplicationJob
      queue_as :importing_job

      def perform(imo, time, has_retry = true, has_import_ais = false)
        spas_ids = Analytic::SpasServices::Importing::ImportProcessing.new(imo: imo, period_time: time).()
        Analytic::SpasServices::LastDeparture.new(imo).()
        Analytic::SpasServices::ProvideDestinationData.new(spas_ids).() if has_import_ais
      rescue Analytic::SpasServices::Importing::ImportProcessingError => e
        if has_retry
          Analytic::SpasJob::RepDataVerifyJob.set(wait: 1.hour).perform_later(imo, time)
        end
      end
    end
  end
end
