module Analytic
  module V1
    module Charts
      class StageTrend1Serializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :jsmea_mac_mainturb_load do |object|
          object.spec['jsmea_mac_mainturb_load']
        end

        attribute :jsmea_mac_mainturb_revolution do |object|
          object.spec['jsmea_mac_mainturb_revolution']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
