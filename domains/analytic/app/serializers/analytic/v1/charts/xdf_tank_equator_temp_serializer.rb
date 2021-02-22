module Analytic
  module V1
    module Charts
      class XdfTankEquatorTempSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_equator_temp do |object|
          object.spec['jsmea_mac_cargotk1_equator_temp']
        end

        attribute :jsmea_mac_cargotk2_equator_temp do |object|
          object.spec['jsmea_mac_cargotk2_equator_temp']
        end

        attribute :jsmea_mac_cargotk3_equator_temp do |object|
          object.spec['jsmea_mac_cargotk3_equator_temp']
        end

        attribute :jsmea_mac_cargotk4_equator_temp do |object|
          object.spec['jsmea_mac_cargotk4_equator_temp']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
