module Analytic
  class SpasMetadata
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    has_many :spases, class_name: Analytic::Spas.name, dependent: :restrict_with_exception

    field :imo_no, type: Integer
    field :dataclass, type: String
    field :datatype, type: String
    field :revisionno, type: String
  end
end
