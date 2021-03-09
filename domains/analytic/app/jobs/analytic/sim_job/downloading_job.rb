module Analytic
  module SimJob
    class DownloadingJob < ApplicationJob
      queue_as :downloading_job

      def perform(job_id)
        job = Analytic::Download.find(job_id)
        job.status = :running
        job.save!
        Analytic::DownloadServices::SimDataToCsv.new(
          imo: job.imo_no,
          condition: job.condition,
          download_job: job
        ).()

        job.status = :success
        job.save!
      rescue
        job.status = :error
        job.save!
      ensure
        Analytic::SimJob::QueueNextJob.perform_later
      end
    end
  end
end