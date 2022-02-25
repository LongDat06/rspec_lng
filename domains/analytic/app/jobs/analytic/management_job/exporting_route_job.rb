module Analytic
  module ManagementJob
    class ExportingRouteJob < ApplicationJob
      queue_as :downloading_job
      sidekiq_options retry: false

      def perform(port, pacific_route, sort_by, sort_order, job_id)
        url = Analytic::ManagementServices::Exporting::Route.new(port, pacific_route, sort_by, sort_order).call
        send_broadcast(job_id, url)
      end

      def send_broadcast(job_id, url)
        ActionCable.server.broadcast("exporting_job_for_#{job_id}", { msg: "done", url: url })
      end
    end
  end
end

