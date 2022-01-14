module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class StageMgoConsumption < Base

          def specific_group_at_time
            {
              "jsmea_mac_boiler_mgoline_mgo_flowcounter_foc": { "$last": "$spec.jsmea_mac_boiler_mgoline_mgo_flowcounter_foc" },
              "jsmea_mac_dieselgeneratorset_total_flowcounter_foc": { "$last": "$spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc" },
              "jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc": { "$last": "$spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc" }
            }
          end

          def specific_group_day
            {
              sum_boiler_mgoline_mgo: { "$sum": "$jsmea_mac_boiler_mgoline_mgo_flowcounter_foc" },
              count_boiler_value: { "$sum": count_without_blank("$jsmea_mac_boiler_mgoline_mgo_flowcounter_foc") },

              sum_foc: { "$sum": "$jsmea_mac_dieselgeneratorset_total_flowcounter_foc" },
              count_foc_value: { "$sum": count_without_blank("$jsmea_mac_dieselgeneratorset_total_flowcounter_foc") },

              sum_diesel_total_fgc: { "$sum": "$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc" },
              count_diesel_value: { "$sum": count_without_blank("$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc") },
            }
          end

          def project
            {
              "$project": {
                            average_value: {"$cond": [ { "$and": [
                                                    { "$ne": ["$count_boiler_value", 0 ] },
                                                    { "$ne": ["$count_foc_value", 0 ] },
                                                    { "$ne": ["$count_diesel_value", 0 ] }
                                                  ]
                                        }, get_value_aday, nil] },
                          }
            }
          end

          private

          def get_value_aday
            {"$divide": [{"$subtract" => [sum_diesel_fg_and_boiler, calculate_without_blank("$sum_diesel_total_fgc")] }, 24] }
          end

          def sum_diesel_fg_and_boiler
            {"$sum": [calculate_without_blank("$sum_boiler_mgoline_mgo"), calculate_without_blank("$sum_foc")]}
          end

        end
      end
    end
  end
end
