# frozen_string_literal: true

module Analytic
  class DownloadJobStatusChannel < ApplicationCable::Channel
    def subscribed
      stream_from "download_job_for_#{params[:job]}"
    end

    def unsubscribed
      stop_all_streams
    end
  end
end
