module Analytic
  module SimJob
    class ImportingJob < ApplicationJob
      def perform
        Analytic::SimServices::Importing::ImportProcessing.new.()
      end

    end
  end
end
