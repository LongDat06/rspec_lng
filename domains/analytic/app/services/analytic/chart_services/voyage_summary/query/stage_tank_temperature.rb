module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class StageTankTemperature < Base

          def specific_group_at_time
            {
              "jsmea_mac_cargotk1_equator_temp": { "$last": "$spec.jsmea_mac_cargotk1_equator_temp" },
              "jsmea_mac_cargotk2_equator_temp": { "$last": "$spec.jsmea_mac_cargotk2_equator_temp" },
              "jsmea_mac_cargotk3_equator_temp": { "$last": "$spec.jsmea_mac_cargotk3_equator_temp" },
              "jsmea_mac_cargotk4_equator_temp": { "$last": "$spec.jsmea_mac_cargotk4_equator_temp" }
            }
          end

          def specific_group_day
            {
              avg_cargotk1: { "$avg": "$jsmea_mac_cargotk1_equator_temp"},

              avg_cargotk2: { "$avg": "$jsmea_mac_cargotk2_equator_temp"},

              avg_cargotk3: { "$avg": "$jsmea_mac_cargotk3_equator_temp"},

              avg_cargotk4: { "$avg": "$jsmea_mac_cargotk4_equator_temp"}
            }
          end
         
          def project
            {
              "$project": { 
                            avg_cargotk1: "$avg_cargotk1",

                            avg_cargotk2: "$avg_cargotk2",

                            avg_cargotk3: "$avg_cargotk3",

                            avg_cargotk4: "$avg_cargotk4",
                          }
            }
          end

        end
      end
    end
  end
end
