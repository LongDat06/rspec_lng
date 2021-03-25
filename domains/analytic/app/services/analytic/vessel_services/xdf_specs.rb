module Analytic
  module VesselServices
    class XdfSpecs
      def initialize(imo, time)
        @imo = imo
        @time = time.to_datetime
      end

      def call
        vessel_specs
      end

      private
      def vessel_specs
        Analytic::Sim
          .imo(@imo.to_i)
          .closest_to_time(@time)
          .only(
            '_id',
            'spec.jsmea_nav_gnss_sog',
            'spec.jsmea_nav_speedlog_log',
            'spec.jsmea_mac_engineroom_air_temp',
            'spec.jsmea_mac_sw_temp',
            'spec.jsmea_mac_mainengine_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset1_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset2_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset3_fuelmode',
            'spec.jsmea_mac_dieselgeneratorset4_fuelmode',
            'spec.jsmea_mac_mainengine_fuelmode',
            'spec.jsmea_nav_gnss_eca',
            'spec.jsmea_nav_trackcontrolsystem_course_direction',
            'spec.jsmea_nav_windindicator_wind_true_direction',
            'spec.jsmea_nav_windindicator_wind_true_speed',
            'spec.jsmea_mac_ship_mgo_total_flowcounter_foc',
            'spec.jsmea_mac_ship_fg_flowcounter_fgc',
            'spec.jsmea_mac_ship_total_include_gcu_fc',
            'spec.jsmea_mac_mainengine2_fuelmode',
            'spec.ts'
          ).first
      end
    end
  end
end
