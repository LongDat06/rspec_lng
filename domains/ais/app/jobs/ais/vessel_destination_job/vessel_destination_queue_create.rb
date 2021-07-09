module Ais
  module VesselDestinationJob
    class VesselDestinationQueueCreate < ApplicationJob
      queue_as :ais

      def perform
        target_imos.each do |imo|
          Ais::VesselDestinationJob::ImportVesselDestination.perform_later(
            imo, current_time.beginning_of_day, current_time.end_of_day, start_checkpoint_everday
          )
        end
      end

      private
      def target_imos
        @target_imos ||= Ais::Vessel.target(true).pluck(:imo)
      end

      def current_time
        @current_time ||= Time.current.utc
      end

      def start_checkpoint_everday
        1
      end
    end
  end
end
