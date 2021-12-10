module Analytic
  module ManagementJob
    class ExportingRouteJob < ApplicationJob
      queue_as :downloading_job
      sidekiq_options retry: false

      def perform(user_id, port, pacific_route, sort_by, sort_order)
        url = Analytic::ManagementServices::Exporting::Route.new(port, pacific_route, sort_by, sort_order).call
        send_broadcast(user_id, url)
      end

      def send_broadcast(user_id, url)
        ActionCable.server.broadcast("exporting_job_for_#{user_id}", { msg: "done", url: url })
      end
    end
  end
end

