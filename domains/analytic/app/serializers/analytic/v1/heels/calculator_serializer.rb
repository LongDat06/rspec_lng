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
                   :consuming_lng
      end
    end
  end
end
