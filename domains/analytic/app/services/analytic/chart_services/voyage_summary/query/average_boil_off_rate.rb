module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class AverageBoilOffRate < Base

          def specific_group_at_time
            {"jsmea_mac_cargotk_bor_include_fv": { "$last": "$spec.jsmea_mac_cargotk_bor_include_fv" }}
          end

          def specific_group_day
            {
              average_value: { "$avg": "$jsmea_mac_cargotk_bor_include_fv"}
            }
          end

        end
      end
    end
  end
end
