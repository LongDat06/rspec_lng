module Analytic
  module ManagementJob
    class ExportingFocJob < ApplicationJob
      queue_as :downloading_job
      sidekiq_options retry: false

      def perform(user_id, imo, sort_by, sort_order)
        url = Analytic::ManagementServices::Exporting::Foc.new(imo, sort_by, sort_order).call
        send_broadcast(user_id, url)
      end

      def send_broadcast(user_id, url)
        ActionCable.server.broadcast("exporting_job_for_#{user_id}", { msg: "done", url: url })
      end
    end
  end
end

