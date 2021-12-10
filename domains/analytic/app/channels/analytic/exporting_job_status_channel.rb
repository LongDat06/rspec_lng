# frozen_string_literal: true

module Analytic
  class ExportingJobStatusChannel < ApplicationCable::Channel
    def subscribed
      stream_from "exporting_job_for_#{params[:user_id]}"
    end

    def unsubscribed
      stop_all_streams
    end
  end
end

