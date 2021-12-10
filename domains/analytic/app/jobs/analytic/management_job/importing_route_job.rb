module Analytic
  module ManagementJob
    class ImportingRouteJob < ApplicationJob
      queue_as :importing_job
      sidekiq_options retry: false

      def perform(file_name, user_id)
        Analytic::ManagementServices::Importing::Route.new(file_name, user_id).()
        send_broadcast(user_id)
      end

      def send_broadcast(user_id)
        ActionCable.server.broadcast("importing_job_for_#{user_id}", { msg: "done" })
      end
    end
  end
end
