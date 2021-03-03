module Analytic
  module V1
    module Charts
      class XdfTrend316Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_mainengine_fuelmode do |object|
          object.spec['jsmea_mac_mainengine_fuelmode']
        end

        attribute :jsmea_mac_mainengine2_fuelmode do |object|
          object.spec['jsmea_mac_mainengine2_fuelmode']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
