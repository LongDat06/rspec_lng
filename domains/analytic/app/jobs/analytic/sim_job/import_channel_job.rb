module Analytic
  module SimJob
    class ImportChannelJob < ApplicationJob
      queue_as :import_channel_job

      def perform(imo)
        Analytic::SimServices::Importing::SimChannel.new(imo: imo).()
      end
    end
  end
end
