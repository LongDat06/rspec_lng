module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class CargoVolumn < Base

          def specific_group_at_time
            {"jsmea_mac_cargotk_total_volume_ave": { "$last": "$spec.jsmea_mac_cargotk_total_volume_ave" }}
          end

          def specific_group_day
            {
              average_value: { "$avg": "$jsmea_mac_cargotk_total_volume_ave"}
            }
          end

        end
      end
    end
  end
end

