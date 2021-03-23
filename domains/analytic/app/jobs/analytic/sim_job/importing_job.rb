module Analytic
  module SimJob
    class ImportingJob < ApplicationJob
      queue_as :importing_job

      TIME_STEP = 1

      def perform
        Analytic::UtilityServices::RailsDateRange.new(time_range).().every(hours: TIME_STEP).each do |time|
          target_imos.each do |imo|
            Analytic::SimJob::IosDataVerifyJob.set(wait_until: time).perform_later(imo, time)
          end
        end
      end

      private
      def time_range
        @time_range ||= (Time.current.beginning_of_day..Time.current.end_of_day)
      end

      def target_imos
        @target_imos ||= Analytic::Vessel.target(true).pluck(:imo)
      end
    end
  end
end
