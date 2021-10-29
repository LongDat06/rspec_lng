module Analytic
  module V1
    module Charts
      class StageTotalFocSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_totalplant_mgo_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_totalplant_mgo_total_flowcounter_foc']
        end

        attribute :jsmea_mac_totalplant_fg_total_flowcounter_fgc do |object|
          object.spec['jsmea_mac_totalplant_fg_total_flowcounter_fgc']
        end

        attribute :jsmea_mac_totalplant_total_flowcounter_fc do |object|
          object.spec['jsmea_mac_totalplant_total_flowcounter_fc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
