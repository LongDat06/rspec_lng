module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class XdfTankTemperature < Base

          def specific_group_at_time
            {"jsmea_mac_vrcompressor_gas_in_temp": { "$last": "$spec.jsmea_mac_vrcompressor_gas_in_temp" }}
          end

          def specific_group_day
            {
              average_value: { "$avg": "$jsmea_mac_vrcompressor_gas_in_temp"}
            }
          end

        end
      end
    end
  end
end

