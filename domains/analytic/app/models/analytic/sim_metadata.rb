module Analytic
  class SimMetadata
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Uploader::AttachmentUploader::Attachment(:meta_imported)
    include Uploader::AttachmentUploader::Attachment(:sim_imported)

    has_many :sims, class_name: Analytic::Sim.name, dependent: :restrict_with_exception

    field :imo_no, type: Integer
    field :dataclass, type: String
    field :datatype, type: String
    field :revisionno, type: String
    field :total_record_no, type: String
    field :meta_imported_data, type: Hash
    field :sim_imported_data, type: Hash
  end
end
