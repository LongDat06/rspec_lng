module Analytic
  module V1
    module Charts
      class StageTrend21Serializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :jsmea_mac_dieselgeneratorset_fo_flow_ave do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fo_flow_ave']
        end

        attribute :jsmea_mac_dieselgeneratorset_fg_flow_ave do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fg_flow_ave']
        end

        attribute :jsmea_mac_forcingvaporizer_gas_out_flow_ave do |object|
          object.spec['jsmea_mac_forcingvaporizer_gas_out_flow_ave']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
