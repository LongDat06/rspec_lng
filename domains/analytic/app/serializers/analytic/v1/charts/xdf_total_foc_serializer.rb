module Analytic
  module V1
    module Charts
      class XdfTotalFocSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_ship_mgo_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_ship_mgo_total_flowcounter_foc']
        end

        attribute :jsmea_mac_ship_fg_flowcounter_fgc do |object|
          object.spec['jsmea_mac_ship_fg_flowcounter_fgc']
        end

        attribute :jsmea_mac_ship_total_include_gcu_fc do |object|
          object.spec['jsmea_mac_ship_total_include_gcu_fc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
