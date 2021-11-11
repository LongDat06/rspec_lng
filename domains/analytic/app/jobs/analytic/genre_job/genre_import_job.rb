module Analytic
  module GenreJob
    class GenreImportJob < ApplicationJob
      queue_as :importing_job
      sidekiq_options retry: 0

      def perform(imo, file_metadata)
        Analytic::GenreServices::Importing::ImportProcessing.new(imo: imo, file_metadata: file_metadata).()
      end
    end
  end
end
