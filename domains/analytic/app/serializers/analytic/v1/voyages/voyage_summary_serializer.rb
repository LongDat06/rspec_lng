module Analytic
  module V1
    module Voyages
      class VoyageSummarySerializer
        include FastJsonapi::ObjectSerializer

        attribute  :imo,
                   :vessel_name,
                   :voyage_name,
                   :voyage_no,
                   :voyage_leg,
                   :port_dept,
                   :atd_lt,
                   :atd_utc,
                   :port_arrival,
                   :ata_lt,
                   :ata_utc,
                   :duration,
                   :distance,
                   :average_speed,
                   :cargo_volume_at_port_of_arrival,
                   :lng_consumption,
                   :mgo_consumption,
                   :average_boil_off_rate,
                   :actual_heel,
                   :adq,
                   :estimated_heel,
                   :estimated_edq,
                   :apply_port_dept,
                   :apply_port_arrival,
                   :apply_atd_lt,
                   :apply_ata_lt,
                   :apply_atd_utc,
                   :apply_ata_utc,
                   :apply_distance,
                   :apply_duration,
                   :apply_average_speed,
                   :manual_port_dept,
                   :manual_port_arrival,
                   :manual_atd_lt,
                   :manual_ata_lt,
                   :manual_atd_utc,
                   :manual_ata_utc,
                   :manual_ata_time_zone,
                   :manual_atd_time_zone,
                   :manual_distance,
                   :manual_duration,
                   :manual_average_speed
      end
    end
  end
end
