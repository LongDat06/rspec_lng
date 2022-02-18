module Analytic
  module V1
    module Charts
      module VoyageSummary
        class SeasonalSummarySerializer
          include FastJsonapi::ObjectSerializer
          set_type :seasonal_voyage_summary_chart
          attribute :duration,
                    :distance,
                    :average_speed,
                    :mgo_consumption,
                    :tooltip_duration,
                    :tooltip_distance,
                    :tooltip_average_speed,
                    :tooltip_mgo_consumption
        end
      end
    end
  end
end
