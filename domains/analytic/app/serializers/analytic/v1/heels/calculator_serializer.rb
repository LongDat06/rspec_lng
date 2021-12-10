module Analytic
  module V1
    module Heels
      class CalculatorSerializer
        include FastJsonapi::ObjectSerializer

        set_type :heel_calculator

        attributes :estimated_distance,
                   :voyage_duration,
                   :required_speed,
                   :estimated_daily_foc,
                   :estimated_daily_foc_season_effect,
                   :estimated_total_foc,
                   :consuming_lng,
                   :etd_time_zone,
                   :eta_time_zone,
                   :etd_label,
                   :eta_label,
                   :eta_utc,
                   :etd_utc

      end
    end
  end
end
