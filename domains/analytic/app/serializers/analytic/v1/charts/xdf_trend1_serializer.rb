module Analytic
  module V1
    module Charts
      class XdfTrend1Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_mainengine_load do |object|
          object.spec['jsmea_mac_mainengine_load']
        end

        attribute :jsmea_mac_mainengine2_load do |object|
          object.spec['jsmea_mac_mainengine2_load']
        end

        attribute :jsmea_mac_mainengine_revolution do |object|
          object.spec['jsmea_mac_mainengine_revolution']
        end

        attribute :jsmea_mac_mainengine2_revolution do |object|
          object.spec['jsmea_mac_mainengine2_revolution']
        end

        attribute :jsmea_nav_gnss_sog do |object|
          object.spec['jsmea_nav_gnss_sog']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
