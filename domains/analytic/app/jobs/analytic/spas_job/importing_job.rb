module Analytic
  module SpasJob
    class ImportingJob < ApplicationJob
      queue_as :importing_job

      def perform
        target_imos.each do |imo|
          Analytic::SpasJob::RepDataVerifyJob.set(wait_until: current_time).perform_later(imo, current_time - 1.days)
        end
      end

      private
      def target_imos
        @target_imos ||= Analytic::Vessel.target(true).pluck(:imo)
      end

      def current_time
        @current_time ||= Time.current.utc
      end
    end
  end
end
