module Analytic
  module VoyageSummaryJob
    class ExportJob < ApplicationJob
      queue_as :downloading_job
      sidekiq_options retry: false

      def perform(params = {})
        url = Analytic::VoyageSummaryServices::Exporting::List.new(params: params).call
        send_broadcast(self.job_id, url)
      end

      private

      def send_broadcast(job_id, url)
        ActionCable.server.broadcast("exporting_job_for_#{job_id}", { msg: "done", url: url })
      end
    end
  end
end
