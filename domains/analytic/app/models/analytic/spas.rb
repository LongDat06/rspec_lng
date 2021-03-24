module Analytic
  class Spas
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :spas_metadata, class_name: Analytic::SpasMetadata.name, required: false

    embeds_one :spec, class_name: Analytic::SpasSpec.name, store_as: 'spec'

    field :imo_no, type: Integer

    index({ imo_no: 1 })
  end
end
