module Analytic
  module V1
    module Charts
      class XdfTrend315Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_ship_mgo_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_ship_mgo_total_flowcounter_foc']
        end

        attribute :jsmea_mac_ship_fg_flowcounter_fgc do |object|
          object.spec['jsmea_mac_ship_fg_flowcounter_fgc']
        end

        attribute :jsmea_oil_dieselgeneratorset_fo_in_temp do |object|
          object.spec['jsmea_oil_dieselgeneratorset_fo_in_temp']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
