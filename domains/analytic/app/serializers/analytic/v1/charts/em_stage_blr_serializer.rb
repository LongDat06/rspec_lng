module Analytic
  module V1
    module Charts
      class EmStageBlrSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_boiler_fuelmode do |object|
          object.spec['jsmea_mac_boiler_fuelmode']
        end

        attribute :jsmea_mac_boiler2_fuelmode do |object|
          object.spec['jsmea_mac_boiler2_fuelmode']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
