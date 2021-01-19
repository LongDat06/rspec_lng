module Analytic
  module V1
    module Charts
      class StageTrend1Serializer
        include FastJsonapi::ObjectSerializer

        attribute :created_at,
                  :jsmea_mac_mainturb_load,
                  :jsmea_mac_mainturb_revolution,
                  :jsmea_mac_boiler_total_flowcounter_foc,
                  :jsmea_mac_dieselgeneratorset_total_flowcounter_foc,
                  :total_foc
      end
    end
  end
end
