module Analytic
  class Sim
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Attributes::Dynamic

    belongs_to :sim_metadata, class_name: Analytic::SimMetadata.name, required: false

    index({ jsmea_mac_cargotk_bor_include_fv: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk_bor_exclude_fv: 1 }, { sparse: true })

    scope :boil_off_rate, -> {
      where(:jsmea_mac_cargotk_bor_include_fv.exists => true)
      .or(:jsmea_mac_cargotk_bor_exclude_fv.exists => true)
    }
  end
end
