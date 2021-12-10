module Analytic
  module SimJob
    class ImportingJob < ApplicationJob
      queue_as :importing_job

      TIME_STEP = 1

      def perform(
        time_from = Time.current.beginning_of_day,
        time_to = Time.current.end_of_day,
        target_imos = Analytic::Vessel.target(true).pluck(:imo)
      )
        range = time_range(time_from, time_to)
        # NO need to create job for vessel does not register on ShipDC
        dataset = Analytic::ExternalServices::Shipdc::DataSet.new.fetch
        registered_imos = []
        target_imos.each do |imo|
          dataset[:iosData].each {|item| registered_imos << imo if (item[:shipId] == imo.to_s && !registered_imos.include?(imo))}
        end
        Analytic::UtilityServices::RailsDateRange.new(range).().every(hours: TIME_STEP).each do |time|
          registered_imos.each do |imo|
            Analytic::SimJob::IosDataVerifyJob.set(wait_until: time).perform_later(imo, time)
          end
        end
      end

      private
      def time_range(time_from, time_to)
        @time_range ||= (time_from..time_to)
      end
    end
  end
end
