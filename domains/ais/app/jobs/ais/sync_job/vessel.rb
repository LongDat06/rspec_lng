module Ais
  module SyncJob
    class Vessel < ApplicationJob
      queue_as :sync_vessel
      
      def perform
        Ais::SyncServices::VesselInformation.new.()
      end
    end
  end
end
