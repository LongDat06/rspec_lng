module Analytic
  module V1
    module Edqs
      class HeelResultSerializer
        include FastJsonapi::ObjectSerializer

        attributes :port_dept,
                   :port_arrival,
                   :pacific_route,
                   :etd,
                   :eta,
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
