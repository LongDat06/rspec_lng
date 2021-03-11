module Analytic
  class Download
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    extend Enumerize
    include Uploader::AttachmentUploader::Attachment(:content)

    embeds_one :condition, store_as: 'condtiion', class_name: Analytic::DownloadCondition.name

    enumerize :status, in: [:created, :queued, :running, :success, :error], default: :created
    enumerize :source, in: [:sim, :spas]

    field :imo_no, type: Integer
    field :status, type: String
    field :content_data, type: Hash
    field :author_id, type: Integer

    index({ imo_no: 1 })

    def content_downloadable
      return if content.blank?
      content.url(
        response_content_disposition: ContentDisposition.attachment(content.original_filename),
        public: false
      )
    end
  end
end
