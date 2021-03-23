module Analytic
  module V1
    module Charts
      class XdfTrend317Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_dieselgeneratorset1_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset2_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset3_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset4_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset4_fuelmode']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
