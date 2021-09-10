module Analytic
  module SimJob
    class DownloadingJob < ApplicationJob
      queue_as :downloading_job

      CHANNEL_NAME = "SIMS_DOWNLOAD_DATA".freeze

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
        # fcm_service.send_to_topic(noti_msg(:success))
        job.save!
      rescue StandardError => e
        Airbrake.notify(e)
        job.status = :error
        # fcm_service.send_to_topic(noti_msg(:error))
        job.save!
      ensure
        Analytic::SimJob::QueueNextJob.perform_later
      end

      private

      def fcm_service
        Analytic::FirebaseCM::Fcm.new(CHANNEL_NAME)
      end

      def noti_msg status
        { title: "Sims Data", body: status == :success ? "Fetch new data" : "Fail to fetch new data"}
      end
    end
  end
end
