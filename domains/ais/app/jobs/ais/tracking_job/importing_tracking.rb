module Ais
  module TrackingJob
    class ImportingTracking < ApplicationJob
      queue_as :ais
      
      def perform(imo, from_date, to_date, last_id)
        time_current = Time.current.utc
        opts = Ais::TrackingServices::Importing::ImportProcessing.new(
          imo: imo,
          from_date: from_date,
          to_date: to_date,
          last_id: last_id,
        )
        opts.call
        next_checkpoint = Ais::Tracking
          .where('csm_id IS NOT NULL AND csm_created_at IS NOT NULL')
          .where('csm_created_at >= :from_date AND csm_created_at <= :to_date', from_date: from_date, to_date: to_date)
          .imo(imo).order(csm_id: :desc).first
        return if time_current > to_date && !opts.data_existed
        return if time_current > to_date && next_checkpoint.blank?
        Ais::TrackingJob::ImportingTracking.set(wait: 1.minutes).perform_later(imo, from_date, to_date, next_checkpoint&.csm_id.presence || 1)
      rescue
        Ais::TrackingJob::ImportingTracking.set(wait: 1.minutes).perform_later(imo, from_date, to_date, last_id)
      end
    end
  end
end
