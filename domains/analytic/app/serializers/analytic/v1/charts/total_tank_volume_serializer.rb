module Analytic
  module V1
    module Charts
      class TotalTankVolumeSerializer
        include FastJsonapi::ObjectSerializer

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
