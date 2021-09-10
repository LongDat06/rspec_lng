module Analytic
  module SimJob
    class IosDataVerifyJob < ApplicationJob
      queue_as :importing_job

      def perform(imo, time, has_retry = true, has_import_ais = false, time_step = 'hour')
        from_time = is_timestep_hour(time_step) ? time.beginning_of_hour : time.beginning_of_day
        to_time = is_timestep_hour(time_step) ? time.end_of_hour : time.end_of_day
        sim_ids = Analytic::SimServices::Importing::ImportProcessing.new(
          imo: imo, 
          period_from: from_time,
          period_to: to_time
        ).()
        Analytic::SimServices::ProvideAisData.new(sim_ids).() if has_import_ais
      rescue Analytic::SimServices::Importing::ImportProcessingError => e
        if has_retry
          Analytic::SimJob::IosDataVerifyJob.set(wait: 1.hour).perform_later(imo, time, has_retry, has_import_ais)
        end
      end

      private

      def is_timestep_hour(time_step)
        time_step == 'hour'
      end
    end
  end
end
