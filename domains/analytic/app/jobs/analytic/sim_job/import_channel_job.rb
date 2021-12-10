module Analytic
  module SimJob
    class ImportChannelJob < ApplicationJob
      queue_as :import_channel_job

      def perform(imo)
        vessel = Analytic::Vessel.find_by_imo(imo)
        return unless vessel.present?

        Analytic::SimServices::Importing::SimChannel.new(imo: imo, data_type: vessel.sim_data_type).()
      end
    end
  end
end
