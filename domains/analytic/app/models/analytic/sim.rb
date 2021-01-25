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
    index({ jsmea_mac_boiler_fo_flow_ave: 1 }, { sparse: true })
    index({ jsmea_mac_boiler_fg_flow_ave: 1 }, { sparse: true })
    index({ jsmea_mac_dieselgeneratorset_fo_flow_ave: 1 }, { sparse: true })
    index({ jsmea_mac_dieselgeneratorset_fg_flow_ave: 1 }, { sparse: true })
    index({ jsmea_mac_forcingvaporizer_gas_out_flow_ave: 1 }, { sparse: true })
    index({ jsmea_mac_boilerdumpstmcontvalve_opening: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk1_volume_percent: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk2_volume_percent: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk3_volume_percent: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk4_volume_percent: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk_total_volume_ave: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk1_equator_temp: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk2_equator_temp: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk3_equator_temp: 1 }, { sparse: true })
    index({ jsmea_mac_cargotk4_equator_temp: 1 }, { sparse: true })


  end
end
