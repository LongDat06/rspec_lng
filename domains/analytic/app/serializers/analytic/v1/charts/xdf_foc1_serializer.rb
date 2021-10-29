module Analytic
  module V1
    module Charts
      class XdfFoc1Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_mainengine_fgline_fg_flowcounter_fgc do |object|
          object.spec['jsmea_mac_mainengine_fgline_fg_flowcounter_fgc']
        end

        attribute :jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc']
        end

        attribute :jsmea_mac_gcu_fg_flowcounter_fgc do |object|
          object.spec['jsmea_mac_gcu_fg_flowcounter_fgc']
        end

        attribute :jsmea_mac_mainengine_mainline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_mainengine_mainline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset_mainline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset_mainline_mgo_flowcounter_foc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
