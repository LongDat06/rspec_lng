module Analytic
  class ReportFile < ApplicationRecord
    FOC = "foc"
    ROUTE = "route"
    include Uploader::AttachmentUploader::Attachment(:file_content)

    def self.fetch_report_url(source)
      self.find_by_source(source)&.file_content&.url
    end
  end
end
