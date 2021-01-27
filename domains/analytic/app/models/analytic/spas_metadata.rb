module Analytic
  class SpasMetadata
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Uploader::AttachmentUploader::Attachment(:meta_imported)
    include Uploader::AttachmentUploader::Attachment(:spas_imported)

    has_many :spases, class_name: Analytic::Spas.name, dependent: :restrict_with_exception

    field :imo_no, type: Integer
    field :dataclass, type: String
    field :datatype, type: String
    field :revisionno, type: String
    field :total_record_no, type: String
    field :meta_imported_data, type: Hash
    field :spas_imported_data, type: Hash
  end
end
