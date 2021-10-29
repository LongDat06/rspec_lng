module Analytic
  module V1
    module Charts
      class BlrFlowSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_boiler_fo_flow_ave do |object|
          object.spec['jsmea_mac_boiler_fo_flow_ave']
        end

        attribute :jsmea_mac_boiler_fg_flow_ave do |object|
          object.spec['jsmea_mac_boiler_fg_flow_ave']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end

      end
    end
  end
end
