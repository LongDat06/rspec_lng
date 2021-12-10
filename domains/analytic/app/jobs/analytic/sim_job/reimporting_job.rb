module Analytic
  module SimJob
    class ReimportingJob < ApplicationJob
      include ManageSidekiqJob
      queue_as :importing_job

      def perform(imo, data_type)
        vessel = Analytic::Vessel.find_by_imo(imo)
        return if vessel.blank?

        delete_schedule_jobs(imo)
        vessel&.update(sim_data_type: data_type)
        Analytic::SimServices::Importing::ReimportAllRelatedSimTable.new(imo, data_type).()
      end
    end
  end
end
