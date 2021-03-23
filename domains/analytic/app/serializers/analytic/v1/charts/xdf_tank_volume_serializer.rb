module Analytic
  module V1
    module Charts
      class XdfTankVolumeSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_volume do |object|
          object.spec['jsmea_mac_cargotk1_volume']
        end

        attribute :jsmea_mac_cargotk2_volume do |object|
          object.spec['jsmea_mac_cargotk2_volume']
        end

        attribute :jsmea_mac_cargotk3_volume do |object|
          object.spec['jsmea_mac_cargotk3_volume']
        end

        attribute :jsmea_mac_cargotk4_volume do |object|
          object.spec['jsmea_mac_cargotk4_volume']
        end

        attribute :jsmea_mac_cargotk_total_volume_ave do |object|
          object.spec['jsmea_mac_cargotk_total_volume_ave']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
