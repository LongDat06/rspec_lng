module Analytic
  module V1
    module Charts
      class StageTrend21Serializer
        include FastJsonapi::ObjectSerializer

        attribute :created_at,
                  :jsmea_mac_boiler_fo_flow_ave,
                  :jsmea_mac_boiler_fg_flow_ave,
                  :jsmea_mac_dieselgeneratorset_fo_flow_ave,
                  :jsmea_mac_dieselgeneratorset_fg_flow_ave,
                  :jsmea_mac_forcingvaporizer_gas_out_flow_ave,
                  :jsmea_mac_boilerdumpstmcontvalve_opening
      end
    end
  end
end
