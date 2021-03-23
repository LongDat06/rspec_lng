module Analytic
  module V1
    module Charts
      class StageTrend32Serializer
        include FastJsonapi::ObjectSerializer

        set_id :_id

        attribute :foc_hfo, :foc_mgo, :fgc

        attribute :jsmea_nav_gnss_sog do |object|
          object.spec['jsmea_nav_gnss_sog']
        end

        attribute :jsmea_nav_speedlog_log do |object|
          object.spec['jsmea_nav_speedlog_log']
        end

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

        attribute :jsmea_mac_boiler_mgoline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_boiler_mgoline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset1_mainline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_mainline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset2_mainline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_mainline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset3_mainline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_mainline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset1_pilotline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_pilotline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset2_pilotline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_pilotline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset3_pilotline_mgo_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_pilotline_mgo_flowcounter_foc']
        end

        attribute :jsmea_mac_boiler_fgline_fg_flowcounter_fgc do |object|
          object.spec['jsmea_mac_boiler_fgline_fg_flowcounter_fgc']
        end

        attribute :jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc do |object|
          object.spec['jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
