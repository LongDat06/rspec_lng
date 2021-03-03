module Analytic
  module V1
    module Charts
      class XdfTrend315Serializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :total_foc

        attribute :jsmea_mac_boiler_foline_hfo_flowcounter_foc do |object|
          object.spec['jsmea_mac_boiler_foline_hfo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset1_mainline_hfo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_mainline_hfo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset2_mainline_hfo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_mainline_hfo_flowcounter_foc']
        end


        attribute :jsmea_mac_dieselgeneratorset3_mainline_hfo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_mainline_hfo_flowcounter_foc']
        end

        attribute :jsmea_oil_dieselgeneratorset_fo_in_temp do |object|
          object.spec['jsmea_oil_dieselgeneratorset_fo_in_temp']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
