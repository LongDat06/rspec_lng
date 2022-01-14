module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class XdfMgoConsumption < Base

          def specific_group_at_time
            {
              "jsmea_mac_ship_fg_flowcounter_fgc": { "$last": "$spec.jsmea_mac_ship_fg_flowcounter_fgc" },
              "jsmea_mac_ship_total_include_gcu_fc": { "$last": "$spec.jsmea_mac_ship_total_include_gcu_fc" },
            }
          end

          def specific_group_day
            {
              sum_lng_consumption: { "$sum": "$jsmea_mac_ship_fg_flowcounter_fgc" },
              count_lng_value: { "$sum": count_without_blank("$jsmea_mac_ship_fg_flowcounter_fgc") },

              sum_mgo_consumption: { "$sum": "$jsmea_mac_ship_total_include_gcu_fc" },
              count_mgo_value: { "$sum": count_without_blank("$jsmea_mac_ship_total_include_gcu_fc") },
            }
          end

          def project
            {
              "$project": {
                            average_value: {"$cond": [ { "$and": [
                                                    { "$ne": ["$count_lng_value", 0 ] },
                                                    { "$ne": ["$count_mgo_value", 0 ] },
                                                  ]
                                        }, get_value_aday, nil] },
                          }
            }
          end

          private

          def get_value_aday
            {"$divide": [{"$subtract" => [calculate_without_blank("$sum_mgo_consumption"), calculate_without_blank("$sum_lng_consumption")]}, 24]}
          end

        end
      end
    end
  end
end

