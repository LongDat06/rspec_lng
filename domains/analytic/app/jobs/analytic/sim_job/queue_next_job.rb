module Analytic
  module SimJob
    class QueueNextJob < ApplicationJob
      queue_as :downloading_job

      def perform
        ActiveRecord::Base.transaction do
          job_created = Analytic::Download.where(status: :created).order_by(created_at: 1).limit(1)
          return if job_created.first.blank?
          Analytic::SimJob::DownloadingJob.perform_later(job_created.first.id.to_s)
        end
      end
    end
  end
end
