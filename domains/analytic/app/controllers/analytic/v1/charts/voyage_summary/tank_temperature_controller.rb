module Analytic
  module V1
    module Charts
      module VoyageSummary
        class TankTemperatureController < BaseController
          def index
            engine_type = Analytic::Vessel.get_engine_type(params[:imo].to_i)

            service_name = {
              "xdf" => Analytic::VoyageSummary::XDF_TANK_TEMPERATURE_CHART
            }

            service_charts = {
              "xdf" => Analytic::ChartServices::VoyageSummary::SingleFieldChart,
              "stage" => Analytic::ChartServices::VoyageSummary::StageTankTemperatureChart
            }

            serializer_types = {
              "xdf" => Analytic::V1::Charts::VoyageSummary::XdfTankTemperatureSerializer,
              "stage" => Analytic::V1::Charts::VoyageSummary::StageTankTemperatureSerializer
            }

            charts = service_charts[engine_type].new(
              voyage_id: params[:voyage_id],
              chart_name: service_name[engine_type]
            ).()

            json_charts = serializer_types[engine_type].new(charts).serializable_hash
            json_response(json_charts)
          end
        end
      end
    end
  end
end
