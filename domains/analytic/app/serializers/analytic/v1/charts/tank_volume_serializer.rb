module Analytic
  module V1
    module Charts
      class TankVolumeSerializer
        include FastJsonapi::ObjectSerializer

        attribute :created_at,
                  :jsmea_mac_cargotk1_volume_percent,
                  :jsmea_mac_cargotk2_volume_percent,
                  :jsmea_mac_cargotk3_volume_percent,
                  :jsmea_mac_cargotk4_volume_percent,
                  :jsmea_mac_cargotk_total_volume_ave
      end
    end
  end
end
