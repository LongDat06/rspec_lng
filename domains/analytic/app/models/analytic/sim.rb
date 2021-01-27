module Analytic
  class Sim
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :sim_metadata, class_name: Analytic::SimMetadata.name, required: false

    embeds_one :spec, class_name: Analytic::SimSpec.name, store_as: 'spec'

    field :imo_no, type: Integer

    index({ imo_no: 1 })
  end
end
