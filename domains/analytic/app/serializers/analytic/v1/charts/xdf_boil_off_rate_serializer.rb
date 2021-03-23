module Analytic
  module V1
    module Charts
      class XdfBoilOffRateSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk_bor_include_fv do |object|
          object.spec['jsmea_mac_cargotk_bor_include_fv']
        end

        attribute :jsmea_mac_cargotk_bor_exclude_fv do |object|
          object.spec['jsmea_mac_cargotk_bor_exclude_fv']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
