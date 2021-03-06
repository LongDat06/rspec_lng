module Analytic
  module V1
    module Charts
      class XdfTrend315Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_ship_mgo_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_ship_mgo_total_flowcounter_foc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
