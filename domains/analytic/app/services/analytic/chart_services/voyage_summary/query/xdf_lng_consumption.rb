module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class XdfLngConsumption < Base

          def specific_group_at_time
            {"jsmea_mac_ship_fg_flowcounter_fgc": { "$last": "$spec.jsmea_mac_ship_fg_flowcounter_fgc" }}
          end

          def specific_group_day
            {
              sum_value: { "$sum": "$jsmea_mac_ship_fg_flowcounter_fgc"},
              count_value: { "$sum": count_without_blank("$jsmea_mac_ship_fg_flowcounter_fgc") },
            }
          end

          def project
            {
              "$project": {
                            average_value: {"$cond": [ { "$ne": ["$count_value", 0 ] }, get_value_aday, nil] },
                          }
            }
          end

          private
          def get_value_aday
            {"$divide": ["$sum_value", 24]}
          end
        end
      end
    end
  end
end

