module Analytic
  module V1
    module Vessels
      class StageSpecsSerializer
        include FastJsonapi::ObjectSerializer
        set_type :stage_spec

        attribute :jsmea_nav_gnss_sog do |object|
          object.spec['jsmea_nav_gnss_sog']
        end

        attribute :jsmea_nav_speedlog_log do |object|
          object.spec['jsmea_nav_speedlog_log']
        end

        attribute :jsmea_mac_engineroom_air_temp do |object|
          object.spec['jsmea_mac_engineroom_air_temp']
        end

        attribute :jsmea_mac_sw_temp do |object|
          object.spec['jsmea_mac_sw_temp']
        end

        attribute :jsmea_mac_boiler_fuelmode do |object|
          object.spec['jsmea_mac_boiler_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset1_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset1_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset2_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset2_fuelmode']
        end

        attribute :jsmea_mac_dieselgeneratorset3_fuelmode do |object|
          object.spec['jsmea_mac_dieselgeneratorset3_fuelmode']
        end

        attribute :jsmea_nav_gnss_eca do |object|
          object.spec['jsmea_nav_gnss_eca']
        end

        attribute :jsmea_nav_trackcontrolsystem_course_direction do |object|
          object.spec['jsmea_nav_trackcontrolsystem_course_direction']
        end

        attribute :jsmea_nav_windindicator_wind_true_direction do |object|
          object.spec['jsmea_nav_windindicator_wind_true_direction']
        end

        attribute :jsmea_nav_windindicator_wind_true_speed do |object|
          object.spec['jsmea_nav_windindicator_wind_true_speed']
        end

        attribute :jsmea_nav_windindicator_wind_true_speed do |object|
          object.spec['jsmea_nav_windindicator_wind_true_speed']
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

        attribute :jsmea_mac_boiler_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_boiler_total_flowcounter_foc']
        end

        attribute :jsmea_mac_dieselgeneratorset_total_flowcounter_foc do |object|
          object.spec['jsmea_mac_dieselgeneratorset_total_flowcounter_foc']
        end

        attribute :timestamp do |object|
          object.spec['ts']
        end
      end
    end
  end
end
