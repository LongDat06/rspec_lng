module Analytic
  module SimJob
    class IosDataVerifyJob < ApplicationJob
      queue_as :importing_job

      def perform(imo, time)
        Analytic::SimServices::Importing::ImportProcessing.new(imo: imo, period_hour: time).()
      rescue Analytic::SimServices::Importing::ImportProcessingError => e
        Analytic::SimJob::IosDataVerifyJob.set(wait: 1.hour).perform_later(imo, time)
      end
    end
  end
end
