module Analytic
  module V1
    module Charts
      class StageTrend33Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_boiler_fuelmode do |object|
          object.spec['jsmea_mac_boiler_fuelmode']
        end

        attribute :jsmea_mac_boiler2_fuelmode do |object|
          object.spec['jsmea_mac_boiler2_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset1_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset2_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset3_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_fuelmode']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
