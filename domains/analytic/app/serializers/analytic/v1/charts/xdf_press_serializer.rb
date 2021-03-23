module Analytic
  module V1
    module Charts
      class XdfPressSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_cargotk1_press_ave do |object|
          object.spec['jsmea_mac_cargotk1_press_ave']
        end

        attribute :jsmea_mac_cargotk2_press_ave do |object|
          object.spec['jsmea_mac_cargotk2_press_ave']
        end

        attribute :jsmea_mac_cargotk3_press_ave do |object|
          object.spec['jsmea_mac_cargotk3_press_ave']
        end

        attribute :jsmea_mac_cargotk4_press_ave do |object|
          object.spec['jsmea_mac_cargotk4_press_ave']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
