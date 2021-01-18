module Analytic
  module V1
    module Charts
      class BoilOffRateSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk_bor_include_fv, :jsmea_mac_cargotk_bor_exclude_fv, :created_at
      end
    end
  end
end
