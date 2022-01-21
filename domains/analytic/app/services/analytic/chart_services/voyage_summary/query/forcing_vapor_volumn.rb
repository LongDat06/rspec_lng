module Analytic
  module ChartServices
    module VoyageSummary
      module Query
        class ForcingVaporVolumn < Base

          def specific_group_at_time
            {"jsmea_mac_forcingvaporizer_gas_out_flow_ave": { "$last": "$spec.jsmea_mac_forcingvaporizer_gas_out_flow_ave" }}
          end

          def specific_group_day
            {
              average_value: { "$avg": "$jsmea_mac_forcingvaporizer_gas_out_flow_ave"}
            }
          end

        end
      end
    end
  end
end

