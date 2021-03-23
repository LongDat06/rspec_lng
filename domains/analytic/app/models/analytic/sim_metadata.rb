module Analytic
  class SimMetadata
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    has_many :sims, class_name: Analytic::Sim.name, dependent: :restrict_with_exception

    field :imo_no, type: Integer
    field :dataclass, type: String
    field :datatype, type: String
    field :revisionno, type: String
  end
end
