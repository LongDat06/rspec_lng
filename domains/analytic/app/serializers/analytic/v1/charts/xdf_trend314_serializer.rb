module Analytic
  module V1
    module Charts
      class XdfTrend314Serializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_dieselgeneratorset_fg_flow_ave do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fg_flow_ave']
        end

        attribute :jsmea_mac_dieselgeneratorset_fo_flow_ave do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fo_flow_ave']
        end

        attribute :jsmea_mac_forcingvaporizer_gas_out_flow_ave do |object|
          object.spec['jsmea_mac_forcingvaporizer_gas_out_flow_ave']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
