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
        send_broadcast(job_id)
      rescue StandardError => e
        Airbrake.notify(e)
        job.status = :error
        job.save!
        send_broadcast(job_id)
      ensure
        Analytic::SimJob::QueueNextJob.perform_later
      end

      private

      def send_broadcast(job_id)
        ActionCable.server.broadcast("download_job_for_#{job_id}", { msg: "done" })
      end

    end
  end
end
