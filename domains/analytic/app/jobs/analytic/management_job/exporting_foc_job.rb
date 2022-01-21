module Analytic
  module ManagementJob
    class ExportingFocJob < ApplicationJob
      queue_as :downloading_job
      sidekiq_options retry: false

      def perform(imo, sort_by, sort_order)
        url = Analytic::ManagementServices::Exporting::Foc.new(imo, sort_by, sort_order).call
        send_broadcast(self.job_id, url)
      end

      def send_broadcast(job_id, url)
        ActionCable.server.broadcast("exporting_job_for_#{job_id}", { msg: "done", url: url })
      end
    end
  end
end

