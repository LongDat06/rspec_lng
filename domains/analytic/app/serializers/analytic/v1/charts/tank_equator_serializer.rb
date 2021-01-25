module Analytic
  module V1
    module Charts
      class TankEquatorSerializer
        include FastJsonapi::ObjectSerializer

        attribute :created_at,
                  :jsmea_mac_cargotk1_equator_temp,
                  :jsmea_mac_cargotk2_equator_temp,
                  :jsmea_mac_cargotk3_equator_temp,
                  :jsmea_mac_cargotk4_equator_temp
      end
    end
  end
end
