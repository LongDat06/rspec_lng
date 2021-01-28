module Analytic
  module V1
    module Charts
      class StageTrend1Serializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :total_foc

        attribute :jsmea_mac_mainturb_load do |object|
          object.spec['jsmea_mac_mainturb_load']
        end

        attribute :jsmea_mac_mainturb_revolution do |object|
          object.spec['jsmea_mac_mainturb_revolution']
        end

        attribute :jsmea_mac_boiler_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_boiler_total_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset_total_flowcounter_foc']
        end

        attribute :timestamp do |object|
          object.spec['timestamp']
        end
      end
    end
  end
end
