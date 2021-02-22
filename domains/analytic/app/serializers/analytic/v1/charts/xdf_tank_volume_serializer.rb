module Analytic
  module V1
    module Charts
      class XdfTankVolumeSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_volume_percent do |object|
          object.spec['jsmea_mac_cargotk1_volume_percent']
        end

        attribute :jsmea_mac_cargotk2_volume_percent do |object|
          object.spec['jsmea_mac_cargotk2_volume_percent']
        end

        attribute :jsmea_mac_cargotk3_volume_percent do |object|
          object.spec['jsmea_mac_cargotk3_volume_percent']
        end

        attribute :jsmea_mac_cargotk4_volume_percent do |object|
          object.spec['jsmea_mac_cargotk4_volume_percent']
        end

        attribute :jsmea_mac_cargotk_total_volume_ave do |object|
          object.spec['jsmea_mac_cargotk_total_volume_ave']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
