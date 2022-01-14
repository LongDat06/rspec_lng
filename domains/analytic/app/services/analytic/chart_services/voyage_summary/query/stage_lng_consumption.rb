module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class StageLngConsumption < Base

          def specific_group_at_time
            {
              "jsmea_mac_boiler_fgline_fg_flowcounter_fgc": { "$last": "$spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc" },
              "jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc": { "$last": "$spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc" },

            }
          end

          def specific_group_day
            {
              sum_boiler: { "$sum": "$jsmea_mac_boiler_fgline_fg_flowcounter_fgc"},
              count_boiler_value: { "$sum": count_without_blank("$jsmea_mac_boiler_fgline_fg_flowcounter_fgc") },
              sum_diesel: { "$sum": "$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc"},
              count_diesel_value: { "$sum": count_without_blank("$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc") },
            }
          end

          def project
            {
              "$project": {
                            average_value: {"$cond": [ { "$and": [
                                                    { "$ne": ["$count_boiler_value", 0 ] },
                                                    { "$ne": ["$count_diesel_value", 0 ] }
                                                  ]
                                        }, get_value_aday, nil] },
                          }
            }
          end

          private

          def get_value_aday
            {"$divide": [{"$sum": [calculate_without_blank("$sum_boiler"), calculate_without_blank("$sum_diesel")] }, 24] }
          end

        end
      end
    end
  end
end
