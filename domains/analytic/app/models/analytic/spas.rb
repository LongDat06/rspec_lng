module Analytic
  class Spas
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :spas_metadata, class_name: Analytic::SpasMetadata.name, required: false

    embeds_one :spas_spec, store_as: 'spec'

    field :imo_no, type: Integer

    index({ imo_no: 1 })
  end
end
