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
                   :estimated_edq
      end
    end
  end
end
