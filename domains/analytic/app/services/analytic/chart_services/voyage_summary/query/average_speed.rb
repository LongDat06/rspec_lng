module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class AverageSpeed < Base

          def specific_group_at_time
            {"jsmea_nav_gnss_sog": { "$last": "$spec.jsmea_nav_gnss_sog" }}
          end

          def specific_group_day
            {
              average_value: { "$avg": "$jsmea_nav_gnss_sog"},
              count_value: { "$sum": count_without_blank("$jsmea_nav_gnss_sog") }
            }
          end

        end
      end
    end
  end
end

