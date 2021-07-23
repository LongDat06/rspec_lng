module Analytic
  class Sim
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    belongs_to :sim_metadata, class_name: Analytic::SimMetadata.name, required: false

    embeds_one :spec, class_name: Analytic::SimSpec.name, store_as: 'spec'

    field :imo_no, type: Integer

    scope :imo, ->(imo) { where(imo_no: imo) if imo.present? }
    scope :closest_to_time, -> (time) {
      return unless time.present?
      data = where('spec.ts' => { "$lte" => time }).order('spec.ts' => -1) 
      data = where('spec.ts' => { "$gte" => time }).order('spec.ts' => 1) if data.blank?
      data
    }

    index(imo_no: 1)
    index "spec.ts" => 1
  end
end
