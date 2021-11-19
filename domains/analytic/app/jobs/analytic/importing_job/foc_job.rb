module Analytic
  module ImportingJob
    class FocJob < ApplicationJob
      queue_as :importing_job

      def perform(file_name)
        Analytic::ImportingServices::Foc.new(file_name).()
      end
    end
  end
end
