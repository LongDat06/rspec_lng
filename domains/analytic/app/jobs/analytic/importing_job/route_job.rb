module Analytic
  module ImportingJob
    class RouteJob < ApplicationJob
      queue_as :importing_job

      def perform(file_name)
        Analytic::ImportingServices::Route.new(file_name).()
      end

    end
  end
end
