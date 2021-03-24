module Analytic
  module SpasJob
    class RepDataVerifyJob < ApplicationJob
      queue_as :importing_job

      def perform(imo, time)
        Analytic::SpasServices::Importing::ImportProcessing.new(imo: imo, period_time: time).()
      rescue Analytic::SpasServices::Importing::ImportProcessingError => e
        Analytic::SpasJob::RepDataVerifyJob.set(wait: 1.hour).perform_later(imo, time)
      end
    end
  end
end
