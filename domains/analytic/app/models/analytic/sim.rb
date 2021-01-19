module Analytic
  class Sim
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Attributes::Dynamic

    belongs_to :sim_metadata, class_name: Analytic::SimMetadata.name, required: false

    index({ jsmea_mac_cargotk_bor_include_fv: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk_bor_exclude_fv: 1 }, { sparse: true })
    index({ jsmea_mac_mainturb_load: 1 }, { sparse: true })
    index({ jsmea_mac_mainturb_revolution: 1 }, { sparse: true })
    index({ jsmea_mac_boiler_total_flowcounter_foc: 1 }, { sparse: true })
    index({ jsmea_mac_dieselgeneratorset_total_flowcounter_foc: 1 }, { sparse: true })

  end
end
