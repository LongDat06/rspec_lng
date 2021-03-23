module Analytic
  module V1
    module Charts
      class XdfInnerSurfaceTempSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_innersurface_upp_temp do |object|
          object.spec['jsmea_mac_cargotk1_innersurface_upp_temp']
        end

        attribute :jsmea_mac_cargotk1_innersurface_low_temp do |object|
          object.spec['jsmea_mac_cargotk1_innersurface_low_temp']
        end

        attribute :jsmea_mac_cargotk2_innersurface_upp_temp do |object|
          object.spec['jsmea_mac_cargotk2_innersurface_upp_temp']
        end

        attribute :jsmea_mac_cargotk2_innersurface_low_temp do |object|
          object.spec['jsmea_mac_cargotk2_innersurface_low_temp']
        end

        attribute :jsmea_mac_cargotk3_innersurface_upp_temp do |object|
          object.spec['jsmea_mac_cargotk3_innersurface_upp_temp']
        end

        attribute :jsmea_mac_cargotk3_innersurface_low_temp do |object|
          object.spec['jsmea_mac_cargotk3_innersurface_low_temp']
        end

        attribute :jsmea_mac_cargotk4_innersurface_upp_temp do |object|
          object.spec['jsmea_mac_cargotk4_innersurface_upp_temp']
        end

        attribute :jsmea_mac_cargotk4_innersurface_low_temp do |object|
          object.spec['jsmea_mac_cargotk4_innersurface_low_temp']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
