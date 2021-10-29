module Analytic
  module V1
    module Charts
      class XdfMeSerializer
        include FastJsonapi::ObjectSerializer

        attribute :jsmea_mac_mainengine_fg_in_flow do |object|
          object.spec['jsmea_mac_mainengine_fg_in_flow']
        end

        attribute :jsmea_mac_mainengine2_fg_in_flow do |object|
          object.spec['jsmea_mac_mainengine2_fg_in_flow']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
