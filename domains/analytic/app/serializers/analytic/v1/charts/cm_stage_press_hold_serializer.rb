module Analytic
  module V1
    module Charts
      class CmStagePressHoldSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_holdspace1_press_ave do |object|
          object.spec['jsmea_mac_holdspace1_press_ave']
        end

        attribute :jsmea_mac_holdspace2_press_ave do |object|
          object.spec['jsmea_mac_holdspace2_press_ave']
        end

        attribute :jsmea_mac_holdspace3_press_ave do |object|
          object.spec['jsmea_mac_holdspace3_press_ave']
        end

        attribute :jsmea_mac_holdspace4_press_ave do |object|
          object.spec['jsmea_mac_holdspace4_press_ave']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
