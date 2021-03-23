module Analytic
  module V1
    module Charts
      class StageTankLiquidTempSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_liquid_temp do |object|
          object.spec['jsmea_mac_cargotk1_liquid_temp']
        end

        attribute :jsmea_mac_cargotk2_liquid_temp do |object|
          object.spec['jsmea_mac_cargotk2_liquid_temp']
        end

        attribute :jsmea_mac_cargotk3_liquid_temp do |object|
          object.spec['jsmea_mac_cargotk3_liquid_temp']
        end

        attribute :jsmea_mac_cargotk4_liquid_temp do |object|
          object.spec['jsmea_mac_cargotk4_liquid_temp']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
