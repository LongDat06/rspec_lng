module Analytic
  module V1
    module Edqs
      class HeelResultSerializer
        include FastJsonapi::ObjectSerializer

        attributes :port_dept_name,
                   :port_dept_id,
                   :port_arrival_name,
                   :port_arrival_id,
                   :master_route_name,
                   :master_route_id,
                   :etd,
                   :etd_label,
                   :etd_utc,
                   :etd_time_zone,
                   :eta,
                   :eta_label,
                   :eta_utc,
                   :eta_time_zone,
                   :estimated_distance,
                   :voyage_duration,
                   :required_speed,
                   :estimated_daily_foc,
                   :estimated_daily_foc_season_effect,
                   :estimated_total_foc,
                   :consuming_lng



      end
    end
  end
end
