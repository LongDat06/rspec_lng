# frozen_string_literal: true

module Analytic
  class ImportingJobStatusChannel < ApplicationCable::Channel
    def subscribed
      stream_from "importing_job_for_#{params[:job]}"
    end

    def unsubscribed
      stop_all_streams
    end
  end
end
